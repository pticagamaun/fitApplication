//
//  UIView + Extensions.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

extension UIView {
    func addShadowOnView() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.7
    }
    
    func addViews(_ view: [UIView]) {
        let views = view
        for view in views {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
}
