//
//  GreenButton.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 13.11.2022.
//

import UIKit

class GreenButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init(type: .system)
        self.setTitle(text, for: .normal)
        configure()
    }
    
    func configure() {
        backgroundColor = .specialGreen
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = .robotoMedium16
        tintColor = .white
    }
    
}
