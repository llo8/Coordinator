
import Foundation

open class BaseCoordinator: NSObject, Coordinator {
    public var childCoordinators: [Coordinator] = []

    public weak var parentCoordinator: BaseCoordinator?

    public var rootCoordinator: Coordinator? {
        var parent = parentCoordinator
        while let prevParent = parent?.parentCoordinator {
            parent = prevParent
        }
        return parent
    }

    open func start() { start(with: nil) }

    open func start(with option: DeepLinkOption?) { }

    open func performAction(with option: DeepLinkOption) {
        childCoordinators.forEach {
            $0.performAction(with: option)
        }
    }

    open func restart() { restart(with: nil) }

    open func restart(with option: DeepLinkOption?) { }

    // add only unique object
    public func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }

        childCoordinators.append(coordinator)

        if let coordinator = coordinator as? BaseCoordinator {
            coordinator.parentCoordinator = self
        }
    }

    public func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false,
              let coordinator = coordinator else {
            return
        }

        // Clear child-coordinators recursively
        if let coordinator = coordinator as? BaseCoordinator,
           !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.removeDependency($0) })
        }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }

        if let coordinator = coordinator as? BaseCoordinator {
            coordinator.parentCoordinator = nil
        }
    }
}
