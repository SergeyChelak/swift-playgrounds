//
//  BiometryService.swift
//  BiometrySample
//
//  Created by Sergey Chelak on 13.04.2021.
//

import Foundation
import LocalAuthentication

class BiometryService {
        
    typealias AuthenticationCallback = (Bool, Error?) -> Void
    
    enum ServiceError: Error {
        case unknown
    }
    
    private let context = LAContext()
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    private var authReason: String
    
    init(authReason: String) {
        self.authReason = authReason
    }
        
    private func checkPolicy() -> Result<LABiometryType, Error> {
        var error: NSError?
        guard context.canEvaluatePolicy(policy, error: &error) else {
            if let error = error {
                print("Attempt to evaluate policy failed with error:\n\(error)")
            }
            return .failure(error ?? ServiceError.unknown)
        }
        return .success(context.biometryType)
    }
    
    var isAvailable: Bool {
        switch checkPolicy() {
        case .failure(_):
            return false
        default:
            return true
        }
    }
    
    public func authenticateUser(handler: AuthenticationCallback?) {
        switch checkPolicy() {
        case .failure(let error):
            DispatchQueue.main.async {
                handler?(false, error)
            }
            return
        case .success(let type):
            print("Allowed type: \(type.rawValue)")
        }
        context.evaluatePolicy(policy, localizedReason: authReason) { isSuccessfull, error in
            DispatchQueue.main.async {
                if isSuccessfull {
                    handler?(true, nil)
                } else {
                    if let error = error {
                        print("Failure:\(error)")
                    }
                    handler?(false, error ?? ServiceError.unknown)
                }
            }
        }
    }
            
}
