//
//  StartWorkoutReps.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 15.11.2022.
//

import UIKit

class StartWorkoutReps: UIViewController {
    
    private let titleLabel = UILabel(text: "START WORKOUT", textColor: .specialBlack, font: .robotoBold24)
    private let closeButton = CloseButton(type: .system)
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "woman")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let parametersView = RepsWorkoutParameters()
    private let finishButton = GreenButton(text: "FINISH")
    private var workoutModel = WorkoutModel()
    private var numberOfSet = 1
    private let customAlert = CustomAlert()
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        addTargets()
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.backgroundColor = .specialBackground
        view.addSubview(imageView)
        parametersView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        view.addSubview(parametersView)
        view.addSubview(finishButton)
        parametersView.repsWorkoutParametersDelegate = self
    }
    
    private func addTargets() {
        closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishButtonTap), for: .touchUpInside)
    }
    
    @objc private func closeButtonTap() {
        dismiss(animated: true)
    }
    
    @objc private func finishButtonTap() {
        
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            secondAlert(title: "Warning!", message: "You really want to finished your workout?") {
                self.dismiss(animated: true)
            }
        }
    }
    
    //MARK: - Public Funcs
    public func setModel(_ model: WorkoutModel) {
        workoutModel = model
    }
}


//MARK: - RepsWorkoutParametersProtocol
extension StartWorkoutReps: RepsWorkoutParametersProtocol {
    func editingButtonTapped() {
        customAlert.presentCustomAlert(viewController: self, repsOrTimer: "Reps") { [weak self] setsNumber, repsNumber in
            guard let self = self else {return}
            if setsNumber != "" && repsNumber != "" {
                guard let numberOfSets = Int(setsNumber),
                      let numberOfReps = Int(repsNumber) else { return }
                RealmManager.shared.updateRepsSetsWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               reps: numberOfReps)
                self.parametersView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
        }
    }
    
    func nextSetButtonTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            parametersView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        } else {
            secondAlert(title: "Error", message: "Want to finish your workot?") {
                self.finishButtonTap()
            }
        }
    }
}


//MARK: - Constraints
extension StartWorkoutReps {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            //closeButton
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            //imageView
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            //parametersView
            parametersView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            parametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            parametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            parametersView.heightAnchor.constraint(equalToConstant: 265),
            
            //finishButton
            finishButton.topAnchor.constraint(equalTo: parametersView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}
