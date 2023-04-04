//
//  ProfileViewController.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 22.11.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let titleLabel = UILabel(text: "PROFILE", textColor: .specialGray, font: .robotoBold24)
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .darkGray
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let profileHeader = ProfileHeaderView()
    private let profileCollection = ProfileCollectionView()
    private let targetLabel = UILabel(text: "TARGET: 20 workouts", textColor: .specialGray, font: .robotoMedium16)
    private let workoutNowLabel = UILabel(text: "0", textColor: .specialGray, font: .robotoMedium24)
    private let workoutTargetLabel = UILabel(text: "10", textColor: .specialGray, font: .robotoMedium24)
    private var stackView = UIStackView()
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .specialLightBrown
        progressView.progressTintColor = .specialGreen
        progressView.layer.cornerRadius = 14
        progressView.clipsToBounds = true
        progressView.setProgress(0, animated: false)
        progressView.layer.sublayers?[1].cornerRadius = 14
        progressView.subviews[1].clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileCollection.workoutArray = [ResultWorkout]()
        profileCollection.getWorkoutResults()
        profileCollection.reloadData()
        setupUserParameters()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
        setDelegates()
    }
    
    private func setupView() {
        view.backgroundColor = .specialBackground
        view.addSubview(titleLabel)
        view.addSubview(profileHeader)
        view.addSubview(profileImageView)
        view.addSubview(profileCollection)
        view.addSubview(targetLabel)
        stackView = UIStackView(arrangedSubviews: [workoutNowLabel, workoutTargetLabel], axis: .horizontal, spacing: 10)
        stackView.distribution = .equalSpacing
        profileCollection.profileViewDelegate = self
        view.addSubview(stackView)
        view.addSubview(progressBar)
    }
    
    private func setDelegates() {
        profileHeader.profileHeaderDelegate = self
    }
    
    private func setupUserParameters() {
        let userArray = RealmManager.shared.getUserModelResults()
        if userArray.count != 0 {
            profileHeader.profileNameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
            profileHeader.heightLabel.text = "Height: \(userArray[0].userHeight)"
            profileHeader.weightLabel.text = "Weight: \(userArray[0].userWeight)"
            targetLabel.text = "Target: \(userArray[0].userTarget) workouts"
            workoutTargetLabel.text = "\(userArray[0].userTarget)"
            guard let imageData = userArray[0].userPhoto,
                  let image = UIImage(data: imageData) else {return}
            profileImageView.image = image
        }
    }
}

//MARK: - ProfileCollectionProtocol
extension ProfileViewController: ProfileCollectionProtocol {
    func didSelectCell() {
        progressBar.setProgress(0.6, animated: true)
    }
}

//MARK: - ProfileHeaderViewProtocol
extension ProfileViewController: ProfileHeaderViewProtocol {
    func tapEditingButton() {
        let settingsVc = SettingsViewController()
        settingsVc.modalPresentationStyle = .fullScreen
        present(settingsVc, animated: true)
    }
}

//MARK: - Constraint
extension ProfileViewController {
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            
            //titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //profileImageView
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            
            //profileHeader
            profileHeader.topAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0),
            profileHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            profileHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            profileHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            //profileCollection
            profileCollection.topAnchor.constraint(equalTo: profileHeader.bottomAnchor, constant: 30),
            profileCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            profileCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            profileCollection.heightAnchor.constraint(equalToConstant: 250),
            
            //targetLabel
            targetLabel.topAnchor.constraint(equalTo: profileCollection.bottomAnchor, constant: 20),
            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            targetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            //stackView
            stackView.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 25),
            
            //progressView
            progressBar.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 2),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            progressBar.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
