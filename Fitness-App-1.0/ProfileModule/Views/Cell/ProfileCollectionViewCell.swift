//
//  ProfileCollectionViewCell.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 22.11.2022.
//

import UIKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let workoutNameLabel = UILabel(text: "PUSH UPS", textColor: .white, font: .robotoBold24)
    private let workoutImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pullUps")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let workoutStat = UILabel(text: "000", textColor: .white, font: .robotoBold48)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .specialDarkYellow
        layer.cornerRadius = 15
        addSubview(workoutNameLabel)
        workoutNameLabel.textAlignment = .center
        addSubview(workoutImageView)
        addSubview(workoutStat)
    }
    
    public func setCell(_ model: ResultWorkout) {
        workoutNameLabel.text = model.name
        workoutStat.text = String(model.result)
        guard let imageData = model.image else {return}
        let image = UIImage(data: imageData)
        workoutImageView.image = image
    }
}

//MARK: - Constraint
extension ProfileCollectionViewCell {
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            //workoutNameLabel
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            workoutNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            workoutNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            //workoutImageView
            workoutImageView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 10),
            workoutImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            workoutImageView.heightAnchor.constraint(equalToConstant: 60),
            workoutImageView.widthAnchor.constraint(equalToConstant: 60),
            
            //workoutStat
            workoutStat.centerYAnchor.constraint(equalTo: workoutImageView.centerYAnchor),
            workoutStat.leadingAnchor.constraint(equalTo: workoutImageView.trailingAnchor, constant: 10)
        ])
    }
    
}
