//
//  DateAndReapeatView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

class DateAndReapeatView: UIView {
    
    private let dateAndRepeatLabel = UILabel(text: "Date and repeat", textColor: .specialLine, font: .robotoMedium14)
    private let subView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .specialLightBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let dateLabel = UILabel(text: "Date", textColor: .specialGray, font: .robotoMedium18)
    private let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .specialGreen
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    private let repeatLabel = UILabel(text: "Repeat every 7 days", textColor: .specialGray, font: .robotoMedium18)
    private let repeatSwitch: UISwitch = {
       let repeatSwitch = UISwitch()
        repeatSwitch.onTintColor = .specialGreen
        repeatSwitch.tintColor = .white
        repeatSwitch.backgroundColor = .specialLightBrown
        repeatSwitch.isOn = true
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        return repeatSwitch
    }()
    
    private var dateStackView = UIStackView()
    private var repeatStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func configure() {
        addSubview(dateAndRepeatLabel)
        addSubview(subView)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .none
        dateStackView = UIStackView(arrangedSubviews: [dateLabel, datePicker], axis: .horizontal, spacing: 10)
        addSubview(dateStackView)
        repeatStackView = UIStackView(arrangedSubviews: [repeatLabel, repeatSwitch], axis: .horizontal, spacing: 10)
        addSubview(repeatStackView)
    }
    
    //MARK: - Public Funcs
    public func getDateAndRepeat() -> (date: Date, repeat: Bool) { // создаем публичную функцию getDateAndRepeat которая не принимает параметров и возвращает tuple date: Date, repeat: Bool
        (datePicker.date, repeatSwitch.isOn)
    }
    
    public func resetValues() {
        datePicker.date = Date()
        repeatSwitch.isOn = true
    }
}

//MARK: - Constraints
extension DateAndReapeatView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //dateAndRepeatLabel
            dateAndRepeatLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            dateAndRepeatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            
            //subView
            subView.topAnchor.constraint(equalTo: dateAndRepeatLabel.bottomAnchor, constant: 3),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            //dateStackView
            dateStackView.topAnchor.constraint(equalTo: subView.topAnchor, constant: 15),
            dateStackView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 10),
            dateStackView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -10),
            dateStackView.heightAnchor.constraint(equalToConstant: 30),
            
            //repeatStackView
            repeatStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 10),
            repeatStackView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 10),
            repeatStackView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -10),
            repeatStackView.heightAnchor.constraint(equalToConstant: 30),
            
        ])
        
    }
    
}
