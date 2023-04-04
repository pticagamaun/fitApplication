//
//  NoWorkoutImage.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 17.11.2022.
//

import UIKit

class NoWorkoutImage: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImage() {
        image = UIImage(named: "noWorkout")
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
}
