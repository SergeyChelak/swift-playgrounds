import Foundation
import UIKit

public extension UIView {
    @discardableResult
    func enableAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
