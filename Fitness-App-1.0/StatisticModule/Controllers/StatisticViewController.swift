//
//  StatisticsViewController.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    private let titleLabel = UILabel(text: "STATISTICS", textColor: .specialBlack, font: .robotoBold24)
    private let segmentedWeekMonth = SegmentedStatistics(items: ["Week","Month"])
    private let searchTextField = BrownTextField()
    private let exercisesLabel = UILabel(text: "Exercises", textColor: .specialLine, font: .robotoMedium14)
    private let statisticsTableView = StatisticsTableView()
    
    private var workoutArray = [WorkoutModel]()
    private var differenceWorkoutArray = [DifferenceWorkout]()
    private var filtredArray = [DifferenceWorkout]()
    private var isFiltred = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        differenceWorkoutArray = [DifferenceWorkout]()
        setStartScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        
        view.backgroundColor = .specialBackground
        view.addSubview(titleLabel)
        view.addSubview(segmentedWeekMonth)
        view.addSubview(searchTextField)
        searchTextField.brownTextFieldDelegate = self
        view.addSubview(exercisesLabel)
        view.addSubview(statisticsTableView)
        segmentedWeekMonth.addTarget(self, action: #selector(segmentedWeekMonthChanged), for: .valueChanged)
    }
    
    @objc private func segmentedWeekMonthChanged() {
        let date = Date().localDate()
        differenceWorkoutArray = [DifferenceWorkout]()
        
        if segmentedWeekMonth.selectedSegmentIndex == 0 {
            let dateStart = date.offsetDay(day: 7)
            getDifferenceModel(dateStart: dateStart)
        } else {
            let dateStart = date.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
        }
        statisticsTableView.reloadData()
    }
    
    private func getWorkoutsNames() -> [String] {
        var nameArray = [String]()
        let resultsWorkout = RealmManager.shared.getWorkoutModelResults()
        
        for workoutModel in resultsWorkout {
            if !nameArray.contains(workoutModel.workoutName){ // если модель не содержит имя
                nameArray.append(workoutModel.workoutName) // поместить его в модель
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        let dateEnd = Date().localDate()
        let nameArray = getWorkoutsNames()
        let allWorkouts = RealmManager.shared.getWorkoutModelResults()
        
        for name in nameArray {
            let predicateDifference = NSPredicate(
                format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd]) // если workoutName из модели = '\(name)' из массива nameArray и workoutDate находится между dateStart, dateEnd, то выполнить данное условие
            let filtredArray = allWorkouts.filter(predicateDifference).sorted(byKeyPath: "workoutDate") // фильтр массива allWorkouts по предикату
            workoutArray = filtredArray.map{$0} // добавить все элементы из filtredArray в workoutArray
            
            guard let last = workoutArray.last?.workoutReps,
                  let first = workoutArray.first?.workoutReps else {return} // вытаскиваем первый и последний элементы массива
            
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: last, firstReps: first)
            differenceWorkoutArray.append(differenceWorkout)
        }
        statisticsTableView.setDifferenceWorkout(model: differenceWorkoutArray)
    }
    
    private func setStartScreen() {
        let date = Date().localDate()
        getDifferenceModel(dateStart: date.offsetDay(day: 7))
        statisticsTableView.reloadData()
    }
    
    private func setSearchTextInArray(text: String) {
        for model in differenceWorkoutArray {
            if model.name.lowercased().contains(text.lowercased()) {
                filtredArray.append(model)
            }
        }
    }
}

//MARK: - BrownTextFieldProtocol
extension StatisticsViewController: BrownTextFieldProtocol {
    func textChange(shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        if let text = searchTextField.text, // опциональная привязка
           let rangeText = Range(range, in: text){ // создаем диапазон символов
            let updateText = text.replacingCharacters(in: rangeText, with: string) // переводим диапазон в String
            filtredArray = [DifferenceWorkout]()
            isFiltred = updateText.count > 0
            setSearchTextInArray(text: updateText)
        }
        
        if isFiltred {
            statisticsTableView.setDifferenceWorkout(model: filtredArray)
        } else {
            statisticsTableView.setDifferenceWorkout(model: differenceWorkoutArray)
        }
        
        statisticsTableView.reloadData()
    }
    
    func tapClear() {
        isFiltred = false
        filtredArray = [DifferenceWorkout]()
        let dateToday = Date().localDate()
        if segmentedWeekMonth.selectedSegmentIndex == 0 {
            getDifferenceModel(dateStart: dateToday.offsetDay(day: 7))
        } else {
            getDifferenceModel(dateStart: dateToday.offsetMonth(month: 1))
        }
        statisticsTableView.reloadData()
    }
    
    
}

//MARK: - Constraints
extension StatisticsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            //titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            //segmentedWeekMonth
            segmentedWeekMonth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedWeekMonth.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            segmentedWeekMonth.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedWeekMonth.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedWeekMonth.heightAnchor.constraint(equalToConstant: 35),
            
            //searchTextField
            searchTextField.topAnchor.constraint(equalTo: segmentedWeekMonth.bottomAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 38),
            
            //exercisesLabel
            exercisesLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            //statisticsTableView
            statisticsTableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            statisticsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
    }
    
}
