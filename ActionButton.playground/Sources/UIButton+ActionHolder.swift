import Foundation
import UIKit

public extension UIButton {
    
    typealias ButtonAction = () -> Void
    
    class ActionHolder: UIView {
        private var action: ButtonAction
        private(set) var event: UIControl.Event
        
        init(event: UIControl.Event, _ action: @escaping ButtonAction) {
            self.action = action
            self.event = event
            super.init(frame: .zero)
            self.isHidden = true
        }
        
        required init?(coder: NSCoder) {
            preconditionFailure("Not allowed")
        }
        
        @objc public func execute(_ sender: AnyObject?) {
            action()
        }
    }
    
    func handle(_ event: UIControl.Event, as action: ButtonAction?) {
        let selector = #selector(ActionHolder.execute(_:))
        subviews.filter {
            guard let actionView = $0 as? ActionHolder else {
                return false
            }
            return actionView.event == event
        }
        .forEach {
            removeTarget($0, action: selector, for: event)
            $0.removeFromSuperview()
        }
        guard let action = action else {
            // just remove existing handler
            return
        }
        let handler = ActionHolder(event: event, action)
        addTarget(handler, action: selector, for: event)
        addSubview(handler)
    }
    
}


