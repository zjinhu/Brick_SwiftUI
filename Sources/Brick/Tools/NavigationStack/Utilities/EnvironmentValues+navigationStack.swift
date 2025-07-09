import SwiftUI

struct UseNavigationStackPolicyKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = UseNavigationStackPolicy.whenAvailable
}

struct IsWithinNavigationStackKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var useNavigationStack: UseNavigationStackPolicy {
        get { self[UseNavigationStackPolicyKey.self] }
        set { self[UseNavigationStackPolicyKey.self] = newValue }
    }
    
    var isWithinNavigationStack: Bool {
        get { self[IsWithinNavigationStackKey.self] }
        set { self[IsWithinNavigationStackKey.self] = newValue }
    }
}
