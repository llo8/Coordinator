
import Foundation

public protocol CompletionCoordinatorFlow {
    var completionFlow: (() -> Void)? { get set }
}
