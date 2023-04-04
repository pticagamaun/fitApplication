//
//  UILabel + Extensions.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, textColor: UIColor!, font: UIFont!, minimumScaleFactor: CGFloat) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.minimumScaleFactor = minimumScaleFactor
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(text: String, textColor: UIColor!, font: UIFont!) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = 2
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(text: String = "") {
        self.init()
        self.text = text
        self.font = .robotoMedium14
        self.textColor = .specialLightBrown
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
