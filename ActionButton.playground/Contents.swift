import UIKit
import PlaygroundSupport

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

