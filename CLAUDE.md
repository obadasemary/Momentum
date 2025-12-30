# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Momentum is a multi-platform SwiftUI application targeting iOS 26.0+, iPadOS, macOS, and visionOS. The project uses Swift 6.2+ with strict concurrency rules, MainActor isolation, and approachable concurrency enabled.

**Development role:** Senior iOS Engineer specializing in SwiftUI, SwiftData, and related Apple frameworks. Code must adhere to Apple's Human Interface Guidelines and App Review guidelines.

## Build and Test Commands

### Building the project

```bash
# Build for all platforms
xcodebuild -project Momentum.xcodeproj -scheme Momentum -configuration Debug build

# Build for specific destination (iOS Simulator)
xcodebuild -project Momentum.xcodeproj -scheme Momentum -destination 'platform=iOS Simulator,name=iPhone 16' build

# Build for macOS
xcodebuild -project Momentum.xcodeproj -scheme Momentum -destination 'platform=macOS' build
```

### Running tests

```bash
# Run all tests
xcodebuild -project Momentum.xcodeproj -scheme Momentum test

# Run tests for specific destination
xcodebuild -project Momentum.xcodeproj -scheme Momentum -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run UI tests only
xcodebuild -project Momentum.xcodeproj -scheme Momentum -only-testing:MomentumUITests test

# Run unit tests only
xcodebuild -project Momentum.xcodeproj -scheme Momentum -only-testing:MomentumTests test
```

### Running a single test

```bash
# Run a specific test by name
xcodebuild -project Momentum.xcodeproj -scheme Momentum -only-testing:MomentumTests/MomentumTests/example test
```

### Linting

```bash
# Run SwiftLint before committing (if installed)
swiftlint
```

## Core Development Guidelines

### Framework Usage

- **SwiftUI only** - Avoid UIKit unless specifically requested
- Use `@Observable` classes (not `ObservableObject`) for shared data
- Always mark `@Observable` classes with `@MainActor`
- Do not introduce third-party frameworks without asking first

### Swift Best Practices

- **Concurrency:** Never use Grand Central Dispatch (`DispatchQueue.main.async`); always use modern Swift concurrency
- **String operations:** Use Swift-native methods like `replacing(_:with:)` instead of Foundation's `replacingOccurrences(of:with:)`
- **URLs:** Use modern Foundation API like `URL.documentsDirectory` and `appending(path:)` instead of older methods
- **Number formatting:** Use `Text(value, format: .number.precision(.fractionLength(2)))` instead of C-style `String(format:)`
- **Static member lookup:** Prefer `.circle` over `Circle()`, `.borderedProminent` over `BorderedProminentButtonStyle()`
- **Text filtering:** Use `localizedStandardContains()` instead of `contains()` for user-input based filtering
- **Error handling:** Avoid force unwraps and force `try` unless unrecoverable
- **Sleep:** Use `Task.sleep(for:)` instead of `Task.sleep(nanoseconds:)`

### SwiftUI Best Practices

- **Styling:** Use `foregroundStyle()` instead of deprecated `foregroundColor()`
- **Shapes:** Use `clipShape(.rect(cornerRadius:))` instead of deprecated `cornerRadius()`
- **Tabs:** Use the `Tab` API instead of `tabItem()`
- **State:** Use `@Observable` classes, never `ObservableObject`
- **onChange:** Use the 2-parameter or 0-parameter variant, never the 1-parameter variant
- **Tap gestures:** Use `Button` unless you specifically need tap location or count; avoid `onTapGesture()`
- **Screen size:** Never use `UIScreen.main.bounds`; use container-relative sizing or GeometryReader alternatives
- **View breakdown:** Extract views into new `View` structs, not computed properties
- **Typography:** Prefer Dynamic Type over hard-coded font sizes; use `bold()` instead of `fontWeight(.bold)`
- **Navigation:** Use `NavigationStack` with `navigationDestination(for:)`, never `NavigationView`
- **Button images:** Always specify text: `Button("Tap me", systemImage: "plus", action: myAction)`
- **Rendering:** Prefer `ImageRenderer` over `UIGraphicsImageRenderer`
- **Layout:** Prefer `containerRelativeFrame()` or `visualEffect()` over `GeometryReader` when possible
- **ForEach:** Don't convert enumerated sequences to arrays: use `ForEach(x.enumerated(), id: \.element.id)` directly
- **Scroll indicators:** Use `.scrollIndicators(.hidden)` modifier, not initializer parameter
- **View models:** Place view logic into view models for testability
- **Type erasure:** Avoid `AnyView` unless absolutely required
- **Spacing:** Avoid hard-coded padding and stack spacing unless requested
- **Colors:** Don't use UIKit colors in SwiftUI code

### SwiftData Guidelines

If using SwiftData with CloudKit:

- Never use `@Attribute(.unique)`
- Model properties must have default values or be optional
- All relationships must be optional

## Architecture

This project follows **Clean Architecture** principles with a modular design, ensuring separation of concerns, testability, and maintainability.

### Architectural Principles

#### 1. Clean Architecture Layers

Dependencies point inward - outer layers depend on inner layers, never the reverse:

```text
┌─────────────────────────────────────────────┐
│   Presentation Layer (Views & ViewModels)  │
│       SwiftUI Views, ViewModels, etc.      │
└──────────────────┬──────────────────────────┘
                   │ depends on
                   ↓
┌─────────────────────────────────────────────┐
│      Business Logic Layer (Use Cases)       │
│         Domain Models, Use Cases            │
└──────────────────┬──────────────────────────┘
                   │ depends on
                   ↓
┌─────────────────────────────────────────────┐
│          Data Layer (Repository)            │
│    Network, Persistence, External APIs      │
└─────────────────────────────────────────────┘
```

**Layer Responsibilities:**

- **Presentation:** UI rendering, user interaction, view state management (no business logic)
- **Business Logic:** Application rules, data transformation, use cases (no UI dependencies)
- **Data:** Data access, network calls, persistence, external services (no business logic)

#### 2. Protocol-Oriented Design

All inter-layer communication happens through protocols:

- Enables testability (easy mocking)
- Provides flexibility (swap implementations)
- Ensures decoupling (layers don't know concrete types)

#### 3. Dependency Injection

All dependencies must be:

- Injected via constructors (never accessed globally)
- Managed through a DI container or composition root
- Resolved explicitly (no implicit dependencies)

#### 4. Unidirectional Data Flow

```text
User Action → View → ViewModel → UseCase → Repository → Network/DB
                ↓        ↓          ↓          ↓           ↓
             Render   Update    Business   Data        External
                      State     Logic      Access      Request
```

#### 5. Actor Isolation (@MainActor)

- Most UI-related classes are `@MainActor` to ensure UI updates on main thread
- Critical for preventing data races in Swift 6's strict concurrency model
- **Do not remove `@MainActor` without careful consideration**

### Design Patterns

#### Builder Pattern

Every feature should have a Builder class that composes views with dependencies.

**Purpose:**

- Centralize dependency injection
- Keep views testable
- Decouple view creation from dependency resolution

**Example:**

```swift
@MainActor
@Observable
final class FeatureBuilder {
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func buildView(router: FeatureRouterProtocol) -> FeatureView {
        let useCase = container.resolve(FeatureUseCaseProtocol.self)
        let viewModel = FeatureViewModel(useCase: useCase, router: router)
        return FeatureView(viewModel: viewModel)
    }
}
```

#### State Machine Pattern

ViewModels should use enum-based state machines for clarity.

**Benefits:**

- Impossible states become impossible
- Clear state transitions
- Easy to test and reason about

**Example:**

```swift
@MainActor
@Observable
final class FeatureViewModel {
    enum State {
        case idle
        case loading
        case loaded(Data)
        case error(Error)
    }

    var state: State = .idle

    func loadData() {
        state = .loading
        Task {
            do {
                let data = try await useCase.fetchData()
                state = .loaded(data)
            } catch {
                state = .error(error)
            }
        }
    }
}
```

#### Repository Pattern

Abstract data sources behind protocols.

**Benefits:**

- Swap implementations (network, cache, mock)
- Single source of truth for data access
- Testability

**Example:**

```swift
protocol DataRepositoryProtocol {
    func fetchData() async throws -> DomainModel
}

final class DataRepository: DataRepositoryProtocol {
    private let networkService: NetworkService

    func fetchData() async throws -> DomainModel {
        let dto = try await networkService.request(endpoint: .data)
        return DomainModel.from(dto)
    }
}
```

#### Adapter Pattern

Transform data between layers to keep them independent.

**Purpose:**

- Map external models to internal models
- Keep layers decoupled
- Add computed properties for views

**Example:**

```swift
struct ItemAdapter {
    let id: String
    let title: String
    let subtitle: String

    static func from(_ domain: DomainItem) -> ItemAdapter {
        ItemAdapter(
            id: domain.id,
            title: domain.name,
            subtitle: domain.description
        )
    }
}
```

### Project Structure

- `Momentum/` - Main application source code
  - `MomentumApp.swift` - App entry point using `@main`
  - `ContentView.swift` - Root view
  - `Assets.xcassets/` - Asset catalog
- `MomentumTests/` - Unit tests
- `MomentumUITests/` - UI tests

**Recommended Structure (as project grows):**

```text
Momentum/
├── Features/
│   ├── FeatureName/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   ├── Models/
│   │   └── Builder/
├── Core/
│   ├── DI/
│   ├── Navigation/
│   └── Extensions/
├── Data/
│   ├── Repositories/
│   ├── Network/
│   └── Persistence/
└── Shared/
    └── Components/
```

### Testing Framework

This project uses **Swift Testing** (not XCTest). Tests are written using the `@Test` macro and `#expect(...)` assertions.

**Example:**

```swift
import Testing

@Test func exampleTest() async throws {
    #expect(value == expectedValue)
}
```

**Testing Strategy:**

- **Unit Tests:** Test ViewModels, Use Cases, Repositories in isolation
- **Protocol-Based Mocks:** Create mock implementations of protocols for testing
- **UI Tests:** Only when unit tests aren't sufficient

**Mock Example:**

```swift
final class MockRepository: DataRepositoryProtocol {
    var stubbedResult: Result<DomainModel, Error>?

    func fetchData() async throws -> DomainModel {
        switch stubbedResult {
        case .success(let data): return data
        case .failure(let error): throw error
        case .none: fatalError("Stubbed result not set")
        }
    }
}
```

### State Management

Use Swift 5.9+ `@Observable` macro (never `ObservableObject`).

**ViewModels:**

```swift
@MainActor
@Observable
final class FeatureViewModel {
    var state: State = .idle
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    // SwiftUI tracks changes automatically
}
```

**Benefits:**

- Less boilerplate than `ObservableObject`
- Automatic change tracking
- Better performance

### Navigation

Use `NavigationStack` with type-safe routing:

```swift
// Define routes
enum Route: Hashable {
    case detail(id: String)
    case settings
}

// In view
NavigationStack {
    ContentView()
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .detail(let id): DetailView(id: id)
            case .settings: SettingsView()
            }
        }
}
```

### Platform Support

The app is configured to run on:

- iOS/iPadOS (TARGETED_DEVICE_FAMILY: 1,2)
- macOS
- visionOS (TARGETED_DEVICE_FAMILY: 7)

**Platform-specific code:**

```swift
#if os(iOS)
// iOS-specific implementation
#elseif os(macOS)
// macOS-specific implementation
#elseif os(visionOS)
// visionOS-specific implementation
#endif
```

### Concurrency

- Swift 6 concurrency enabled with strict checking
- Default actor isolation: `MainActor`
- Use `async/await` for asynchronous operations
- SwiftUI views automatically inherit `@MainActor` isolation
- Never use Grand Central Dispatch

### Common Patterns

#### Error Handling

Map errors at layer boundaries:

```swift
// Repository → UseCase
do {
    return try await networkService.request(endpoint: .data)
} catch let error as URLError {
    throw DomainError.network(error)
} catch {
    throw DomainError.unknown(error)
}

// UseCase → ViewModel
Task {
    do {
        let data = try await useCase.fetch()
        state = .loaded(data)
    } catch {
        state = .error(error)
    }
}
```

#### Pagination

```swift
private var isLoadingMore = false
private var currentPage = 1

func loadMore() {
    guard !isLoadingMore else { return }
    isLoadingMore = true
    defer { isLoadingMore = false }

    currentPage += 1
    // Fetch next page
}

func refresh() {
    currentPage = 1
    items.removeAll()
    loadData()
}
```

### Important Constraints

1. **@MainActor is Critical** - Most UI classes are `@MainActor` for thread safety; removing can cause data races
2. **No Force Unwrapping** - Use safe unwrapping: `if let`, `guard let`, or handle optionals properly
3. **Protocol-First Development** - Always define protocols for cross-module dependencies
4. **Builder Pattern is Mandatory** - Features must be composed via builder classes
5. **One Type Per File** - Each struct/class/enum should have its own file
