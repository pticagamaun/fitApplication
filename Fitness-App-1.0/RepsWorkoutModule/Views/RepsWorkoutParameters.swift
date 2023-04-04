//
//  RepsWorkoutParameters.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 15.11.2022.
//

import UIKit

protocol RepsWorkoutParametersProtocol: AnyObject {
    func editingButtonTapped()
    func nextSetButtonTapped()
}

class RepsWorkoutParameters: UIView {
    
    private let detailsLabel = UILabel(text: "Details", textColor: .specialLine, font: .robotoMedium14)
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .specialLightBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameWorkoutLabel = UILabel(text: "Biceps", textColor: .specialGray, font: .robotoMedium24)
    private let setsLabel = UILabel(text: "Sets", textColor: .specialGray, font: .robotoMedium18)
    private let numberOfSets = UILabel(text: "1/4", textColor: .specialGray, font: .robotoMedium24)
    private let separatorOne: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let repsLabel = UILabel(text: "Reps", textColor: .specialGray, font: .robotoMedium18)
    let numberOfReps = UILabel(text: "20", textColor: .specialGray, font: .robotoMedium24)
    let separatorTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var stackViewSets = UIStackView()
    private var stackViewReps = UIStackView()
    private let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .specialLine
        button.setImage(UIImage(named: "pencil")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleLabel?.font = .robotoMedium14
        button.setTitle("Editing", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextSetButton: UIButton = {
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
    weak var repsWorkoutParametersDelegate: RepsWorkoutParametersProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailsLabel)
        addSubview(backView)
        addSubview(nameWorkoutLabel)
        stackViewSets = UIStackView(arrangedSubviews: [setsLabel, numberOfSets], axis: .horizontal, spacing: 5)
        stackViewSets.distribution = .equalSpacing
        stackViewReps = UIStackView(arrangedSubviews: [repsLabel, numberOfReps], axis: .horizontal, spacing: 5)
        stackViewReps.distribution = .equalSpacing
        addSubview(stackViewSets)
        addSubview(separatorOne)
        addSubview(stackViewReps)
        addSubview(separatorTwo)
        addSubview(editingButton)
        addSubview(nextSetButton)
    }
    
    private func addTargets() {
        editingButton.addTarget(self, action: #selector(editingButtonTap), for: .touchUpInside)
        nextSetButton.addTarget(self, action: #selector(nextSetButtonTap), for: .touchUpInside)
    }
    
    @objc private func editingButtonTap() {
        repsWorkoutParametersDelegate?.editingButtonTapped()
    }
    
    @objc private func nextSetButtonTap() {
        repsWorkoutParametersDelegate?.nextSetButtonTapped()
    }
    
    public func refreshLabels(model: WorkoutModel, numberOfSet: Int) {
        nameWorkoutLabel.text = model.workoutName
        numberOfSets.text = "\(numberOfSet)/\(model.workoutSets)"
        numberOfReps.text = "\(model.workoutReps)"
    }

}

extension RepsWorkoutParameters {
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
