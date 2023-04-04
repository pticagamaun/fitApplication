//
//  CalendarView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

class CalendarView: UIView {
    
    private let callendarCollection = CalendarCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        
        backgroundColor = .specialGreen
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(callendarCollection)
    }
    
    //MARK: - Public Funcs
    public func setDelegate(_ delegate: CalendarCollectionProtocol) {
        callendarCollection.calendarDelegate = delegate
    }
}



//MARK: - Constraints
extension CalendarView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            callendarCollection.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            callendarCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 105),
            callendarCollection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            callendarCollection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
}


