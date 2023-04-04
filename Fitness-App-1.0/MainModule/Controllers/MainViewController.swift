//
//  MainViewController.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    
    private let headerView = HeaderView()
    private let workoutTodayLabel = UILabel(text: "Workout today", textColor: .specialLine, font: .robotoMedium14)
    private let mainTableView = MainTableView()
    private var workoutArray = [WorkoutModel]() // пустой массив с моделью
    private let noWorkoutImage = NoWorkoutImage(frame: .zero)
    lazy var networkWeatherManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        lm.delegate = self
        return lm
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserParameters()
        selectItem(date: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        getWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
//        getWeather()
        requestLocation()
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        view.backgroundColor = .specialBackground
        headerView.headerViewDelegate = self
        headerView.setDelegateCalendarProtocol(self)
        mainTableView.mainTableDelegate = self
    }
    
    private func getWorkouts(date: Date) {
        let weekday = date.getWeekdayNumber()
        let startDay = date.dateEndStart().0
        let endDay = date.dateEndStart().1
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnRepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [startDay, endDay])
        let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnRepeat]) // объединение предикатов
        let resultsArray = RealmManager.shared.getWorkoutModelResults() // получаем все объекты из Realm
        let filtredArray = resultsArray.filter(compoundPredicate).sorted(byKeyPath: "workoutName")// фильтруем объекты по предикату и помещаем в filtredArray
        workoutArray = filtredArray.map{$0} //помещаем отфильтрованный массив в workoutArray
    }
    
    private func checkWorkout() {
        if workoutArray.count == 0 {
            noWorkoutImage.isHidden = false
            mainTableView.isHidden = true
        } else {
            noWorkoutImage.isHidden = true
            mainTableView.isHidden = false
        }
    }
    
    private func setupUserParameters() {
        let userArray = RealmManager.shared.getUserModelResults()
        if userArray.count != 0 {
            headerView.nameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
            guard let imageData = userArray[0].userPhoto,
                  let image = UIImage(data: imageData) else {return}
            headerView.userPhotoImageView.image = image
        }
    }
    
    private func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            networkWeatherManager.requestLocation()
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        NetworkDataFetch.shared.fetchWeatherLocation(lat: latitude, lon: longitude) { [weak self] result, error in
            guard let self = self else {return}
            if let model = result {
                print(model)
                self.headerView.weatherView.updateLabels(model: model)
                NetworkRequest.shared.requestDataLocation(lat: latitude, lon: longitude) { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let data):
                        self.headerView.weatherView.updateImage(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - MainTableViewCellProtocol
extension MainViewController: MainTableViewCellProtocol {
    func startButtonTapped(model: WorkoutModel) {
        let repsVC = StartWorkoutReps()
        let timerVC = StartWorkoutTimer()
        if model.workoutTimer == 0 {
            repsVC.modalPresentationStyle = .fullScreen
            repsVC.setModel(model)
            present(repsVC, animated: true)
        } else {
            timerVC.modalPresentationStyle = .fullScreen
            timerVC.setModel(model)
            present(timerVC, animated: true)
        }
    }
}

//MARK: - MainTableViewProtocol
extension MainViewController: MainTableViewProtocol {
    func deleteModel(model: WorkoutModel, index: Int) {
        RealmManager.shared.deleteWorkoutModel(model)
        workoutArray.remove(at: index) // удаляем ячейку по индексу
        mainTableView.setWorkout(array: workoutArray) // устанавливаем данные массива для новых ячеек
        mainTableView.reloadData() // обновляем таблицу
    }
}

//MARK: - HeaderViewProtocol
extension MainViewController: HeaderViewProtocol {
    func pressButton() {
        let newWorkoutVC = NewWorkoutViewController()
        newWorkoutVC.modalPresentationStyle = .fullScreen
        present(newWorkoutVC, animated: true)
    }
}

//MARK: - CalendarCollectionProtocol
extension MainViewController: CalendarCollectionProtocol {
    func selectItem(date: Date) {
        getWorkouts(date: date) // получаем массив с фильтром по компаунду
        mainTableView.setWorkout(array: workoutArray) // устанавливаем данные массива для ячейки
        mainTableView.reloadData() // обновляем таблицу
        checkWorkout() 
    }
}

//MARK: - Constraints
extension MainViewController {
    
    private func setConstraints() {
        
        view.addSubview(headerView)
        view.addSubview(workoutTodayLabel)
        view.addSubview(mainTableView)
        view.addSubview(noWorkoutImage)
        
        NSLayoutConstraint.activate([
            
            //headerView
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            headerView.heightAnchor.constraint(equalToConstant: 205),
            
            //workoutTodayLabel
            workoutTodayLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            //mainTableView
            mainTableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            //noWorkoutImage
            noWorkoutImage.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 10),
            noWorkoutImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noWorkoutImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noWorkoutImage.heightAnchor.constraint(equalTo: noWorkoutImage.widthAnchor, multiplier: 1)
        ])
    }
    
}


