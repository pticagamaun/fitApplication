//
//  ProfileHeaderView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 22.11.2022.
//

import UIKit

protocol ProfileHeaderViewProtocol: AnyObject {
    func tapEditingButton()
}

final class ProfileHeaderView: UIView {
    
    weak var profileHeaderDelegate: ProfileHeaderViewProtocol?
    
    private let greenShape: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public var profileNameLabel = UILabel(text: "YOUR NAME", textColor: .white, font: .robotoBold24, minimumScaleFactor: 0.5)
    public var heightLabel = UILabel(text: "Height: _", textColor: .specialGray, font: .robotoMedium16)
    public var weightLabel = UILabel(text: "Weight: _", textColor: .specialGray, font: .robotoMedium16)
    private var paramStack = UIStackView()
    lazy var editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Editing", for: .normal)
        button.setImage(UIImage(named: "editing")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .specialGreen
        button.titleLabel?.font = .robotoMedium16
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(greenShape)
        addSubview(profileNameLabel)
        profileNameLabel.textAlignment = .center
        paramStack = UIStackView(arrangedSubviews: [heightLabel, weightLabel], axis: .horizontal, spacing: 15)
        addSubview(paramStack)
        addSubview(editingButton)
    }
    
    @objc private func editingButtonTapped() {
        profileHeaderDelegate?.tapEditingButton()
    }
}

extension ProfileHeaderView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            //greenShape
            greenShape.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            greenShape.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            greenShape.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            greenShape.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            //profileNameLabel
            profileNameLabel.leadingAnchor.constraint(equalTo: greenShape.leadingAnchor, constant: 10),
            profileNameLabel.trailingAnchor.constraint(equalTo: greenShape.trailingAnchor, constant: -10),
            profileNameLabel.bottomAnchor.constraint(equalTo: greenShape.bottomAnchor, constant: -15),
            
            //paramStack
            paramStack.topAnchor.constraint(equalTo: greenShape.bottomAnchor, constant: 8),
            paramStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            paramStack.heightAnchor.constraint(equalToConstant: 17),
            
            //editingButton
            editingButton.topAnchor.constraint(equalTo: greenShape.bottomAnchor, constant: 8),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            editingButton.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
}


