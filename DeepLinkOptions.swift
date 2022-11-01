
import UIKit

public
enum DeepLinkOption {
    // add cases for navigation

    static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
        // FEATURE
        return nil
    }

    static func build(with dict: [String: AnyObject]?) -> DeepLinkOption? {
        // FEATURE
        return nil
    }

    static func build(with shortcutItem: UIApplicationShortcutItem) -> DeepLinkOption? {
        // FEATURE
        return nil
    }
}
