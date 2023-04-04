//
//  MainTableViewCell.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

protocol MainTableViewCellProtocol: AnyObject {
    func startButtonTapped(model: WorkoutModel)
}

class MainTableViewCell: UITableViewCell {
    
    weak var maintTableViewCellDelegate: MainTableViewCellProtocol?
    private let backgroundCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLightBrown
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let subView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let workoutImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pullUps")?.withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let workoutNameLabel = UILabel(text: "Pull Ups", textColor: .specialBlack, font: .robotoBold22)
    private let repsLabel = UILabel(text: "Reps: 10", textColor: .specialGray, font: .robotoMedium16)
    private let setsLabel = UILabel(text: "Sets: 2", textColor: .specialGray, font: .robotoMedium16)
    private var labelsStackView = UIStackView()
    private var workoutModel = WorkoutModel()
    private lazy var startWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .robotoBold18
        button.addShadowOnView()
        button.setTitleColor(UIColor.specialDarkGreen, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startWorkoutButtonTap), for: .touchUpInside)
        return button
    }()
    private var isComplete: Bool = true {
        didSet {
            if isComplete {
                startWorkoutButton.backgroundColor = .specialGreen
                startWorkoutButton.setTitle("COMPLETE", for: .normal)
                startWorkoutButton.tintColor = .white
                startWorkoutButton.isEnabled = false
            } else {
                startWorkoutButton.backgroundColor = .specialYellow
                startWorkoutButton.setTitle("START", for: .normal)
                startWorkoutButton.isEnabled = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func configure() {
        
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(backgroundCellView)
        addSubview(subView)
        subView.addSubview(workoutImageView)
        addSubview(workoutNameLabel)
        labelsStackView = UIStackView(arrangedSubviews: [repsLabel, setsLabel], axis: .horizontal, spacing: 10)
        addSubview(labelsStackView)
        contentView.addSubview(startWorkoutButton)
    }
    
    @objc private func startWorkoutButtonTap() {
        maintTableViewCellDelegate?.startButtonTapped(model: workoutModel)
    }
    
    //MARK: - Public Funcs
    public func configureCell(model: WorkoutModel) {
        workoutModel = model
        workoutNameLabel.text = model.workoutName
        if model.workoutReps == 0 {
            repsLabel.text = "Timer: \(model.workoutTimer.getMinutesAndSeconds())"
        } else {
            repsLabel.text = "Reps: \(model.workoutReps)"
        }
        setsLabel.text = "Sets: \(model.workoutSets)"
        isComplete = model.workoutStatus
        
        guard let imageData = model.workoutImage,
              let image = UIImage(data: imageData) else {return}
        workoutImageView.image = image.withRenderingMode(.alwaysTemplate)
    }
}

extension MainTableViewCell {
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //backgroundCellView
            backgroundCellView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundCellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundCellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            //subView
            subView.centerYAnchor.constraint(equalTo: centerYAnchor),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subView.heightAnchor.constraint(equalToConstant: 70),
            subView.widthAnchor.constraint(equalToConstant: 70),
            
            //workoutImageView
            workoutImageView.topAnchor.constraint(equalTo: subView.topAnchor, constant: 10),
            workoutImageView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 10),
            workoutImageView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -10),
            workoutImageView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -10),
            
            //workoutNameLabel
            workoutNameLabel.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 5),
            workoutNameLabel.leadingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 10),
            workoutNameLabel.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor, constant: -10),
            
            //labelsStackView
            labelsStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 0),
            labelsStackView.leadingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 10),
            labelsStackView.heightAnchor.constraint(equalToConstant: 20),
            
            //startWorkoutButton
            startWorkoutButton.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 3),
            startWorkoutButton.leadingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 10),
            startWorkoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            startWorkoutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
}
