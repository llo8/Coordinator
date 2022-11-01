
import Foundation

public protocol Coordinator: AnyObject {
    func start()
    func start(with option: DeepLinkOption?)
    func performAction(with option: DeepLinkOption)
    func restart()
    func restart(with option: DeepLinkOption?)

    var rootCoordinator: Coordinator? { get }
}
