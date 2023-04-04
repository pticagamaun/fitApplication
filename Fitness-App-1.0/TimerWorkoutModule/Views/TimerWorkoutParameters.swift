//
//  TimerWorkoutParameters.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 15.11.2022.
//

import UIKit

protocol TimerWorkoutParametersProtocol: AnyObject {
    func editingButtonTapped()
    func nextSetButtonTapped()
}

class TimerWorkoutParameters: UIView {
    
    let detailsLabel = UILabel(text: "Details", textColor: .specialLine, font: .robotoMedium14)
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .specialLightBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameWorkoutLabel = UILabel(text: "Squats", textColor: .specialGray, font: .robotoMedium24)
    let setsLabel = UILabel(text: "Sets", textColor: .specialGray, font: .robotoMedium18)
    let numberOfSets = UILabel(text: "1/4", textColor: .specialGray, font: .robotoMedium24)
    let separatorOne: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let timerLabel = UILabel(text: "Time of Set", textColor: .specialGray, font: .robotoMedium18)
    let numberOfTimer = UILabel(text: "1 min 30 sec", textColor: .specialGray, font: .robotoMedium24)
    let separatorTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var stackViewSets = UIStackView()
    var stackViewReps = UIStackView()
    let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .specialLine
        button.setImage(UIImage(named: "pencil")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleLabel?.font = .robotoMedium14
        button.setTitle("Editing", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT SET", for: .normal)
        button.titleLabel?.font = .robotoMedium16
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .specialDarkYellow
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.specialGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    weak var timerWorkoutParametersDelegate: TimerWorkoutParametersProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailsLabel)
        addSubview(backView)
        addSubview(nameWorkoutLabel)
        stackViewSets = UIStackView(arrangedSubviews: [setsLabel, numberOfSets], axis: .horizontal, spacing: 5)
        stackViewSets.distribution = .equalSpacing
        stackViewReps = UIStackView(arrangedSubviews: [timerLabel, numberOfTimer], axis: .horizontal, spacing: 5)
        stackViewReps.distribution = .equalSpacing
        addSubview(stackViewSets)
        addSubview(separatorOne)
        addSubview(stackViewReps)
        addSubview(separatorTwo)
        addSubview(editingButton)
        addSubview(nextSetButton)
    }
    
    //MARK: - Private Funcs
    private func addTargets() {
        editingButton.addTarget(self, action: #selector(editingButtonTap), for: .touchUpInside)
        nextSetButton.addTarget(self, action: #selector(nextSetButtonTap), for: .touchUpInside)
    }
    
    @objc private func editingButtonTap() {
        timerWorkoutParametersDelegate?.editingButtonTapped()
    }
    
    @objc private func nextSetButtonTap() {
        timerWorkoutParametersDelegate?.nextSetButtonTapped()
    }
    
    //MARK: - Public Funcs
    public func refreshLabels(model: WorkoutModel, numberOfSet: Int) {
        nameWorkoutLabel.text = model.workoutName
        numberOfSets.text = "\(numberOfSet)/\(model.workoutSets)"
        numberOfTimer.text = "\(model.workoutTimer.getMinutesAndSeconds())"
    }
    
    public func buttonsIsEnable(_ value: Bool) {
        editingButton.isEnabled = value
        nextSetButton.isEnabled = value
    }
}

extension TimerWorkoutParameters {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //detailsLabel
            detailsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            
            //backView
            backView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 1),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            //nameWorkoutLabel
            nameWorkoutLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            nameWorkoutLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 15),
            
            //stackViewSets
            stackViewSets.topAnchor.constraint(equalTo: nameWorkoutLabel.bottomAnchor, constant: 15),
            stackViewSets.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            stackViewSets.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            stackViewSets.heightAnchor.constraint(equalToConstant: 25),
            
            //separatorOne
            separatorOne.topAnchor.constraint(equalTo: stackViewSets.bottomAnchor, constant: 3),
            separatorOne.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            separatorOne.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            separatorOne.heightAnchor.constraint(equalToConstant: 1),
            
            //stackViewReps
            stackViewReps.topAnchor.constraint(equalTo: stackViewSets.bottomAnchor, constant: 25),
            stackViewReps.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            stackViewReps.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            stackViewReps.heightAnchor.constraint(equalToConstant: 25),
            
            //separatorTwo
            separatorTwo.topAnchor.constraint(equalTo: stackViewReps.bottomAnchor, constant: 3),
            separatorTwo.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            separatorTwo.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            separatorTwo.heightAnchor.constraint(equalToConstant: 1),
            
            //editingButton
            editingButton.topAnchor.constraint(equalTo: separatorTwo.bottomAnchor, constant: 10),
            editingButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            editingButton.heightAnchor.constraint(equalToConstant: 24),
            
            //nextSetButton
            nextSetButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 15),
            nextSetButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            nextSetButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            nextSetButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
