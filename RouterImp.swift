
import UIKit

public final class RouterImp: Router {

    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]

    public init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }

    public func toPresent() -> UIViewController? {
        return rootController
    }

    public func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    public func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }

    public func show(_ module: Presentable?) {
        show(module, animated: true)
    }

    public func show(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        if let viewController = rootController?.presentedViewController {
            viewController.present(controller, animated: animated, completion: nil)
        } else {
            rootController?.present(controller, animated: animated, completion: nil)
        }
    }

    public func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }

    public func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    public func push(_ module: Presentable?, hideBottomBar: Bool) {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }

    public func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }

    public func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }

    public func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent(),
              (controller is UINavigationController == false) else {
            assertionFailure("Deprecated push UINavigationController.")
            return
        }

        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        rootController?.pushViewController(controller, animated: animated)
    }

    public func push(_ module: Presentable?, withDropLast: Bool) {
        push(module, withDropLast: withDropLast, animated: true)
    }

    public func push(_ module: Presentable?, withDropLast: Bool, animated: Bool) {
        if withDropLast {
            let viewController = rootController?.viewControllers.dropLast() ?? []
            rootController?.setViewControllers(
                viewController + [module?.toPresent()].compactMap { $0 },
                animated: animated
            )
        } else {
            push(module, animated: animated)
        }
    }

    public func popModule() {
        popModule(animated: true)
    }

    public func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    public func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }

    public func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }

    public func popToModule<T: Presentable>(_ target: T.Type) {
        if let viewController = rootController?.viewControllers.first(where: { $0 as? T != nil }) {
            rootController?.popToViewController(viewController, animated: false)
        }
    }

    public func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
