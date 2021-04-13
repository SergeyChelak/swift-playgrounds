//
//  UIView+Utils.swift
//  BiometrySample
//
//  Created by Sergey Chelak on 13.04.2021.
//

import Foundation
import UIKit

public extension UIView {
    @discardableResult
    func enableAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func addSubviews(_ views: [UIView]) -> Self {
        for view in views {
            addSubview(view)
        }
        return self
    }
}

public extension Array where Element == NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    
}
