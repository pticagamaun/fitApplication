//
//  SettingsViewController.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 23.11.2022.
//

import UIKit
import PhotosUI

final class SettingsViewController: UIViewController {
    
    private let titleLabel = UILabel(text: "EDITING PROFILE", textColor: .specialGray, font: .robotoBold24)
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .darkGray
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true
        image.image = UIImage(named: "addProfile")
        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let backGreenView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameLabel = UILabel(text: "    First name", textColor: .specialLightGray, font: .robotoBold14)
    private let nameTextField = BrownTextField()
    private let secondNameLabel = UILabel(text: "    Second name", textColor: .specialLightGray, font: .robotoBold14)
    private let secondNameTextField = BrownTextField()
    private let heightLabel = UILabel(text: "    Height", textColor: .specialLightGray, font: .robotoBold14)
    private let heightTextField = BrownTextField()
    private let weightLabel = UILabel(text: "    Weight", textColor: .specialLightGray, font: .robotoBold14)
    private let weightTextField = BrownTextField()
    private let targetLabel = UILabel(text: "    Target", textColor: .specialLightGray, font: .robotoBold14)
    private let targetTextField = BrownTextField()
    private let saveButton = GreenButton(text: "SAVE")
    
    private var firstStackView = UIStackView()
    private var secondStackView = UIStackView()
    private var thirdStackView = UIStackView()
    private var quatroStackView = UIStackView()
    private var fiveStackView = UIStackView()
    private var generalStackView = UIStackView()
    private var userModel = UserModel()
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        addGesture()
        addTargets()
        loadUserInfo()
    }
    
    private func setupView() {
        view.backgroundColor = .specialBackground
        view.addSubview(titleLabel)
        view.addSubview(backGreenView)
        view.addSubview(profileImageView)
        firstStackView = UIStackView(arrangedSubviews: [nameLabel,
                                                        nameTextField], axis: .vertical, spacing: 2)
        view.addSubview(firstStackView)
        secondStackView = UIStackView(arrangedSubviews: [secondNameLabel,
                                                         secondNameTextField], axis: .vertical, spacing: 2)
        view.addSubview(secondStackView)
        thirdStackView = UIStackView(arrangedSubviews: [heightLabel,
                                                        heightTextField], axis: .vertical, spacing: 2)
        view.addSubview(thirdStackView)
        quatroStackView = UIStackView(arrangedSubviews: [weightLabel,
                                                         weightTextField], axis: .vertical, spacing: 2)
        view.addSubview(fiveStackView)
        fiveStackView = UIStackView(arrangedSubviews: [targetLabel,
                                                       targetTextField], axis: .vertical, spacing: 2)
        view.addSubview(quatroStackView)
        generalStackView = UIStackView(arrangedSubviews: [firstStackView,
                                                          secondStackView,
                                                          thirdStackView,
                                                          quatroStackView,
                                                          fiveStackView], axis: .vertical, spacing: 30)
        view.addSubview(generalStackView)
        view.addSubview(saveButton)
    }
    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
    }
    
    @objc private func saveButtonTap() {
        setModel()
        let userArray = RealmManager.shared.getUserModelResults()
        if userArray.count == 0 {
            RealmManager.shared.saveUserModel(userModel)
        } else {
            RealmManager.shared.updateUserModel(userModel)
        }
        userModel = UserModel()
        dismiss(animated: true)
    }
    
    private func loadUserInfo() {
        let userArray = RealmManager.shared.getUserModelResults()
        if userArray.count != 0 {
            nameTextField.text = userArray[0].userFirstName
            secondNameTextField.text = userArray[0].userSecondName
            heightTextField.text = "\(userArray[0].userHeight)"
            weightTextField.text = "\(userArray[0].userWeight)"
            targetTextField.text = "\(userArray[0].userTarget)"
            guard let data = userArray[0].userPhoto,
                  let image = UIImage(data: data) else {return}
            profileImageView.image = image
//            profileImageView.contentMode = .scaleAspectFit
        }
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
    }
    
    @objc private func choosePhoto() {
        photoPikerAlert { [weak self] source in
            guard let self = self else {return}
            if #available(iOS 14.0, *) {
                self.presentPHPicker()
            } else {
                self.chooseImagePicker(source: source)
            }
        }
    }
    
    private func setModel() {
        
        guard let firstName = nameTextField.text,
              let secondName = secondNameTextField.text,
              let height = heightTextField.text,
              let weight = weightTextField.text,
              let target = targetTextField.text else {return}
        
        guard let intHeight = Int(height),
              let intWeight = Int(weight),
              let intTarget = Int(target) else {return}
        
        userModel.userFirstName = firstName
        userModel.userSecondName = secondName
        userModel.userHeight = intHeight
        userModel.userWeight = intWeight
        userModel.userTarget = intTarget
        
        if profileImageView.image == UIImage(named: "addProfile") {
            userModel.userPhoto = nil
        } else {
            guard let imageData = profileImageView.image?.pngData() else {return}
            userModel.userPhoto = imageData
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController() // создаем экземпляр пикера
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source // источник пикера
            present(imagePicker, animated: true) // презентуем пикер
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}

//MARK: - PHPickerViewControllerDelegate
@available(iOS 14.0, *)
extension SettingsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {return}
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                    self.profileImageView.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    private func presentPHPicker() {
        var phPickerCongig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerCongig.selectionLimit = 1
        phPickerCongig.filter = PHPickerFilter.any(of: [.images])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerCongig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
}

//MARK: - Constraints
extension SettingsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            //titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //profileImageView
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 110),
            profileImageView.widthAnchor.constraint(equalToConstant: 110),
            
            //backGreenView
            backGreenView.topAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            backGreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backGreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            backGreenView.heightAnchor.constraint(equalToConstant: 70),
            
            //heighTextFields
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40),
            heightTextField.heightAnchor.constraint(equalToConstant: 40),
            weightTextField.heightAnchor.constraint(equalToConstant: 40),
            targetTextField.heightAnchor.constraint(equalToConstant: 40),
            
            //generalStackView
            generalStackView.topAnchor.constraint(equalTo: backGreenView.bottomAnchor, constant: 40),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            //saveButton
            saveButton.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
