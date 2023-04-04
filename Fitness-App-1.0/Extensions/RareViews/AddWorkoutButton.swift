//
//  AddWorkoutButton.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

class AddWorkoutButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Add workout", for: .normal)
        setImage(UIImage(named: "plus"), for: .normal)
        layer.cornerRadius = 10
        backgroundColor = .specialYellow
        setTitleColor(.specialDarkGreen, for: .normal)
        tintColor = .specialDarkGreen
        imageEdgeInsets = .init(top: 0, left: 20, bottom: 15, right: 0)
        titleEdgeInsets = .init(top: 50, left: -40, bottom: 0, right: 0)
        translatesAutoresizingMaskIntoConstraints = false
        addShadowOnView()
    }
    
    convenience init(font: UIFont?) {
        self.init(type: .system)
        self.titleLabel?.font = font
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
