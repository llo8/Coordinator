
public protocol Router: Presentable {
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)

    func show(_ module: Presentable?)
    func show(_ module: Presentable?, animated: Bool)

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, hideBottomBar: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?)

    func push(_ module: Presentable?, withDropLast: Bool)
    func push(_ module: Presentable?, withDropLast: Bool, animated: Bool)

    func popModule()
    func popModule(animated: Bool)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)

    func popToModule<T: Presentable>(_ target: T.Type)

    func popToRootModule(animated: Bool)
}
