import SwiftUI

@Observable
public final class AppCoordinator {
    public var feedPath = NavigationPath()
    public var selectedTab: AppTab = .feed

    public init() {}

    public func navigate(to route: AppRoute) {
        feedPath.append(route)
    }

    public func popToRoot() {
        feedPath = NavigationPath()
    }
}
