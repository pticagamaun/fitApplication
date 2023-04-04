//
//  NewWorkoutViewController.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

class NewWorkoutViewController: UIViewController {
    
    private let titleLabel = UILabel(text: "NEW WORKOUT", textColor: .specialBlack, font: .robotoBold24)
    private let closeButton = CloseButton(type: .system)
    private let nameView = NameView()
    private let dateAndRepeatView = DateAndReapeatView()
    private let repsOrTimerView = RepsOrTimerView()
    private var stackView = UIStackView()
    private let saveButton = GreenButton(text: "SAVE")
    private var workoutModel = WorkoutModel() // создаем модель типа WorkoutModel которая будет хранить в себе все данные
    private let testImage = UIImage(named: "pullUps")
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestureRecognizers()
        setContstraints()
        addTargets()
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        view.backgroundColor = .specialBackground
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        stackView = UIStackView(arrangedSubviews: [nameView,
                                                   dateAndRepeatView,
                                                   repsOrTimerView], axis: .vertical, spacing: 20)
        view.addSubview(stackView)
        view.addSubview(saveButton)
        
    }
    
    private func addTargets() {
        closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func dismissKeyboard() {
        nameView.hideKeyboard()
    }
    
    @objc private func closeButtonTap() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTap() {
        setModel()
        saveModel()
        
    }
    
    private func setModel() {
        workoutModel.workoutName = nameView.getNameTextFieldText()
        workoutModel.workoutDate = dateAndRepeatView.getDateAndRepeat().date.localDate()
        workoutModel.workoutNumberOfDay = dateAndRepeatView.getDateAndRepeat().date.getWeekdayNumber()
        workoutModel.workoutRepeat = dateAndRepeatView.getDateAndRepeat().repeat
        workoutModel.workoutSets = repsOrTimerView.sets
        workoutModel.workoutReps = repsOrTimerView.reps
        workoutModel.workoutTimer = repsOrTimerView.timer
        guard let imageData = testImage?.pngData() else { return }
        workoutModel.workoutImage = imageData
    }
    
    private func saveModel() {
        let text = nameView.getNameTextFieldText()
        let count = text.filter{$0.isLetter || $0.isNumber}.count
        
        if count != 0 &&
            workoutModel.workoutSets != 0 &&
            (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) {
            RealmManager.shared.saveWorkoutModel(workoutModel)
            createNotifications()
            workoutModel = WorkoutModel()
            simpleAlert(title: "Succes", message: nil)
            resetValues()
        } else {
            simpleAlert(title: "Error", message: "Fill all parameters")
        }
    }
    
    private func resetValues() {
        nameView.resetTextFieldText()
        dateAndRepeatView.resetValues()
        repsOrTimerView.resetValuesSlider()
    }
    
    private func createNotifications() {
        let notifications = Notifications()
        let date = workoutModel.workoutDate.yyyyMMdd()
        notifications.scheduleDateNotifications(date: workoutModel.workoutDate, id: "workout" + date)
    }
}



//MARK: - Contstraints
extension NewWorkoutViewController {
    
    private func setContstraints() {
        
        NSLayoutConstraint.activate([
            //titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            //closeButton
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            //heightViews
            nameView.heightAnchor.constraint(equalToConstant: 60),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 115),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 340),
            
            //stackView
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            //saveButton
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 55),
            
        ])
        
    }
    
}
