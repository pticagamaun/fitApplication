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
    private var workoutArray = [WorkoutModel]()
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestLocation()
        setDelegate()
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        view.backgroundColor = .specialBackground
        view.addViews([headerView, mainTableView, noWorkoutImage, workoutTodayLabel])
        setConstraints()
    }

    private func setDelegate() {
        headerView.headerViewDelegate = self
        headerView.setDelegateCalendarProtocol(self)
        mainTableView.mainTableDelegate = self
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
        workoutArray.remove(at: index)
        mainTableView.setWorkout(array: workoutArray)
        mainTableView.reloadData()
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
        var getWorkoutModel = GetWorkoutModel()
        getWorkoutModel.getWorkouts(date: date)
        self.workoutArray = getWorkoutModel.workoutArray
        mainTableView.setWorkout(array: workoutArray)
        mainTableView.reloadData()
        checkWorkout()
    }
}

//MARK: - Constraints
private extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            headerView.heightAnchor.constraint(equalToConstant: 205),

            workoutTodayLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            mainTableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            noWorkoutImage.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 10),
            noWorkoutImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noWorkoutImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noWorkoutImage.heightAnchor.constraint(equalTo: noWorkoutImage.widthAnchor, multiplier: 1)
        ])
    }
}


