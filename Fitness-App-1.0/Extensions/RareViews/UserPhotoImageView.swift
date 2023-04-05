//
//  UserPhotoImageView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 04.04.2023.
//

import UIKit

class UserPhotoImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        layer.cornerRadius = 50
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
}
