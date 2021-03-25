import UIKit
import PlaygroundSupport

extension UIButton {
    
     class ActionHolder: UIView {
        
        typealias Action = () -> Void
        
        private var action: Action
        private(set) var event: UIControl.Event
        
        init(event: UIControl.Event, _ action: @escaping Action) {
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
    
    func handle(_ event: UIControl.Event, as action: ActionHolder.Action?) {
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

extension UIView {
    @discardableResult
    func enableAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

class DemoController: UIViewController {
    
    let button: UIButton = {
        let button = UIButton().enableAutolayout()
        button.setTitle("My Button", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .magenta
        button.handle(.touchUpInside) {
            print("Touch handled inside action holder")
        }
        return button
    }()
    
    override func loadView() {
        super.loadView()
        self.view = UIView().enableAutolayout()
        setup()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonTouch(_:)), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func buttonTouch(_ sender: AnyObject?) {
        print("Touch handled inside delegate")
        button.handle(.touchUpInside, as: nil)
    }
    
}

let controller = DemoController()
PlaygroundPage.current.liveView = controller
// PlaygroundPage.current.needsIndefiniteExecution = true

