//
//  SegmentedStatistics.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

class SegmentedStatistics: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        selectedSegmentTintColor = .specialYellow
        selectedSegmentIndex = 0
        let font = UIFont(name: "Roboto-Medium", size: 16)
        setTitleTextAttributes([.font: font as Any, .foregroundColor: UIColor.white], for: .normal)
        setTitleTextAttributes([.font : font as Any, .foregroundColor : UIColor.specialGray], for: .selected)
        backgroundColor = .specialGreen
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
