import Orion
import SwiftUI
import UIKit

// Universal settings integration.
// Split into multiple HookGroups so missing classes in newer Spotify builds
// (e.g., RootSettingsViewController removed in 9.1.36) don't crash when activating.
struct UniversalSettingsIntegrationProfileGroup: HookGroup { }
struct UniversalSettingsIntegrationSettingsVCGroup: HookGroup { }
struct UniversalSettingsIntegrationRootSettingsVCGroup: HookGroup { }
struct UniversalSettingsIntegrationNavGroup: HookGroup { }

// 9.1.44 dropped ProfileSettingsSection; Settings root is now SettingsListViewController.
struct UniversalSettingsIntegrationListVCGroup: HookGroup { }

// MARK: - Primary: ProfileSettingsSection hook for settings menu row
class UniversalProfileSettingsSectionHook: ClassHook<NSObject> {
    typealias Group = UniversalSettingsIntegrationProfileGroup
    static let targetName = "ProfileSettingsSection"
    
    func numberOfRows() -> Int {
        return orig.numberOfRows()
    }
    
    func didSelectRow(_ row: Int) {
        orig.didSelectRow(row)
    }
    
    func cellForRow(_ row: Int) -> UITableViewCell {
        return orig.cellForRow(row)
    }
}

// MARK: - Global Helper Stubs (UI Injections Disabled)
func injectEeveeButton(into target: UIViewController) {
    // Disabled: prevents gear button creation in navigation bar
    return
}

func injectEeveeInlineRow(into vc: UIViewController) {
    // Disabled: prevents EeveeSpotify row insertion in settings list
    return
}

// MARK: - Fallback: Hook SettingsViewController directly (New UI)
class SettingsViewControllerHook: ClassHook<UIViewController> {
    typealias Group = UniversalSettingsIntegrationSettingsVCGroup
    static let targetName = "SettingsViewController"

    func viewDidLoad() {
        orig.viewDidLoad()
    }

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
    }
}

// MARK: - Fallback: Hook RootSettingsViewController directly
class RootSettingsViewControllerHook: ClassHook<UIViewController> {
    typealias Group = UniversalSettingsIntegrationRootSettingsVCGroup
    static let targetName = "RootSettingsViewController"

    func viewDidLoad() {
        orig.viewDidLoad()
    }

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
    }
}

class SettingsListViewControllerHook: ClassHook<UIViewController> {
    typealias Group = UniversalSettingsIntegrationListVCGroup
    static let targetName = "_TtC21Settings_PlatformImpl26SettingsListViewController"

    func viewDidLoad() {
        orig.viewDidLoad()
    }

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
    }

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
    }
}

// MARK: - Generic Fallback: Hook UINavigationController
class SettingsNavigationStackHook: ClassHook<UINavigationController> {
    typealias Group = UniversalSettingsIntegrationNavGroup

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        orig.pushViewController(viewController, animated: animated)
    }
}
