//
//  NameView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 13.11.2022.
//

import UIKit

class NameView: UIView {
  
    private let nameLabel = UILabel(text: "Name", textColor: .specialLine, font: .robotoMedium14)
    private let nameTextField = BrownTextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addSubview(nameTextField)
    }
    
    //MARK: - Public Funcs
    public func getNameTextFieldText() -> String { // создаем публичную функцию getNameTextFieldText которая не принимает параметров и возвращает String
        guard let text = nameTextField.text else { return "" } // вытаскиваем текст из nameTextField
        return text
    }
    
    public func hideKeyboard() {
        nameTextField.resignFirstResponder()
    }

    public func resetTextFieldText() {
        nameTextField.text = ""
    }
}

//MARK: - Constraints
extension NameView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            nameTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}

