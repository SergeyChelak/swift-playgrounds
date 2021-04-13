//
//  BiometryViewController.swift
//  BiometrySample
//
//  Created by Sergey Chelak on 13.04.2021.
//

import Foundation
import UIKit

class BiometryViewController: AutolayoutViewController {
    
    let biometryService = BiometryService(authReason: "Keychain access")
    
    private lazy var button: UIButton = {
        let button = UIButton(primaryAction: UIAction(title: "Check biometry") { [unowned self] _ in
            self.startTouchIDAuth()
        })
        button.enableAutolayout()
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.enableAutolayout()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    override func setup() {
        super.setup()
        self.title = "Biometry Sample"
    }
    
    override func addSubviews() {
        view.addSubviews([button, resultLabel])
    }
    
    override func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        [
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            button.widthAnchor.constraint(lessThanOrEqualTo: safeArea.widthAnchor),
            button.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30.0),
            button.heightAnchor.constraint(lessThanOrEqualToConstant: 30.0)
        ].activate()
        
        [
            resultLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 30.0),
            resultLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            resultLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
        ].activate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBiometryViews()
    }
    
    private func startTouchIDAuth() {
        biometryService.authenticateUser { [unowned self] isSuccessfull, error in
            var result: String
            if isSuccessfull {
                result = "Access granted"
            } else {
                self.updateBiometryViews()
                if let error = error {
                    result = "Failed with error:\n\(error)"
                } else {
                    result = "Strange..."
                }
            }
            self.resultLabel.text = result
        }
    }
    
    private func updateBiometryViews() {
        if biometryService.isAvailable {
            button.isHidden = false
            resultLabel.text = ""
        } else {
            button.isHidden = true
            resultLabel.text = "Biometry is not available.\nCheck your settings and try again"
        }
    }
    
}
