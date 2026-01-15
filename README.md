# Momentum

[![iOS Build & Test](https://github.com/obadasemary/Momentum/actions/workflows/CI.yml/badge.svg)](https://github.com/obadasemary/Momentum/actions/workflows/CI.yml)

A multi-platform SwiftUI application built with modern Swift concurrency and Clean Architecture principles.

## Platform Support

- iOS 26.0+
- iPadOS 26.0+
- macOS
- visionOS

## Tech Stack

- **Language**: Swift 6.2 with strict concurrency
- **UI Framework**: SwiftUI (no UIKit)
- **Architecture**: Clean Architecture with MVVM
- **State Management**: `@Observable` macro
- **Testing**: Swift Testing framework
- **Concurrency**: Swift async/await (no GCD)

## Architecture

This project follows **Clean Architecture** with clear separation of concerns:

```text
┌─────────────────────────────────────────────┐
│   Presentation Layer (Views & ViewModels)   │
│       SwiftUI Views, ViewModels, etc.       │
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

### Key Design Patterns

- **Builder Pattern**: Each feature has a Builder class for dependency composition
- **State Machine Pattern**: ViewModels use enum-based state management
- **Repository Pattern**: Data access abstracted behind protocols
- **Adapter Pattern**: Transform data between layers
- **Protocol-Oriented Design**: All inter-layer communication via protocols

### Project Structure

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

## Building the Project

### Build for all platforms

```bash
xcodebuild -project Momentum.xcodeproj -scheme Momentum -configuration Debug build
```

### Build for specific destination

```bash
# iOS Simulator
xcodebuild -project Momentum.xcodeproj -scheme Momentum -destination 'platform=iOS Simulator,name=iPhone 17' build

# macOS
xcodebuild -project Momentum.xcodeproj -scheme Momentum -destination 'platform=macOS' build
```

## Running Tests

### Run all tests

```bash
xcodebuild -project Momentum.xcodeproj -scheme Momentum test
```

### Run specific test suites

```bash
# Unit tests only
xcodebuild -project Momentum.xcodeproj -scheme Momentum -only-testing:MomentumTests test

# UI tests only
xcodebuild -project Momentum.xcodeproj -scheme Momentum -only-testing:MomentumUITests test
```

### Run a single test

```bash
xcodebuild -project Momentum.xcodeproj -scheme Momentum -only-testing:MomentumTests/MomentumTests/testName test
```

## Development Guidelines

### Core Principles

- **SwiftUI only** - no UIKit unless specifically required
- **Protocol-first** - all dependencies via protocols for testability
- **Dependency injection** - no global state or singletons
- **Modern Swift** - use Swift 6 concurrency, avoid legacy patterns
- **Clean Architecture** - strict layer separation with unidirectional data flow

### Code Standards

- Use `@Observable` classes (never `ObservableObject`)
- Use modern Swift concurrency (never Grand Central Dispatch)
- Use Swift-native APIs over Foundation where available
- Prefer static member lookup (`.circle` over `Circle()`)
- Extract views into structs, not computed properties
- Use `NavigationStack` with type-safe routing
- No force unwrapping or force `try`
- One type per file

### Testing

This project uses **Swift Testing** framework:

```swift
import Testing

@Test func exampleTest() async throws {
    #expect(value == expectedValue)
}
```

- Write unit tests for ViewModels, Use Cases, and Repositories
- Use protocol-based mocks for dependencies
- Test business logic in isolation from UI

## SwiftData

If using SwiftData with CloudKit:

- Never use `@Attribute(.unique)`
- Model properties must have default values or be optional
- All relationships must be optional

## Contributing

1. Follow the architecture and patterns outlined in [CLAUDE.md](CLAUDE.md)
2. Ensure all tests pass before committing
3. Run SwiftLint if installed: `swiftlint`
4. Adhere to Apple's Human Interface Guidelines

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
