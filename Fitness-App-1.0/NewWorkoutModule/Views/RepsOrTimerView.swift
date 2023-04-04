//
//  RepsOrTimerView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

class RepsOrTimerView: UIView {
    
    private let repsOrTimerLabel = UILabel(text: "Reps or timer", textColor: .specialLine, font: .robotoMedium14)
    private let subView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .specialLightBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let repeatOrTimerLabel = UILabel(text: "Choose repeat or timer",
                                             textColor: .specialLine,
                                             font: .robotoMedium18)
    private let setsSlider = SliderView(name: "Sets", minValue: 0, maxValue: 10, type: .sets)
    private let repsSlider = SliderView(name: "Reps", minValue: 0, maxValue: 50, type: .reps)
    private let timerSlider = SliderView(name: "Timer", minValue: 0, maxValue: 600, type: .timer)
    private var stackView = UIStackView()
    public var (sets, reps, timer) = (0, 0, 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
        setDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  Private Funcs
    private func configure() {
        addSubview(repsOrTimerLabel)
        addSubview(subView)
        repeatOrTimerLabel.textAlignment = .center
        stackView = UIStackView(arrangedSubviews: [setsSlider, repeatOrTimerLabel, repsSlider, timerSlider],
                                    axis: .vertical, spacing: 20)
        addSubview(stackView)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setDelegates() {
        setsSlider.delegate = self
        repsSlider.delegate = self
        timerSlider.delegate = self
    }
    
    //MARK: - Public Funcs
    public func resetValuesSlider() {
        setsSlider.resetSlider()
        repsSlider.resetSlider()
        timerSlider.resetSlider()
    }
    
}

extension RepsOrTimerView: SliderViewProtocol {
    func changeValue(type: SliderType, value: Int) {
        switch type {
        case .sets:
            sets = value
        case .reps:
            reps = value
            repsSlider.isActive = true
            timerSlider.isActive = false
            timer = 0
        case .timer:
            timer = value
            repsSlider.isActive = false
            timerSlider.isActive = true
            reps = 0
        }
    }
}




extension RepsOrTimerView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //repsOrTimerLabel
            repsOrTimerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            
            //subView
            subView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 3),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            //setsStackView
            stackView.topAnchor.constraint(equalTo: subView.topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -15)
            
        ])
    }
    
}
