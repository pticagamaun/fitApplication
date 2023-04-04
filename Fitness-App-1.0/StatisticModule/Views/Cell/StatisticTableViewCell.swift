//
//  StatisticsTableViewCell.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit


class StatisticsTableViewCell: UITableViewCell {

    private let separator: UIView = {
       let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let differenceLabel = UILabel(text: "+0", textColor: .specialGreen, font: .robotoMedium24)
    private let workoutNameLabel = UILabel(text: "Biceps", textColor: .specialGray, font: .robotoMedium24)
    private var stackView = UIStackView()
    private let beforeLabel = UILabel(text: "Before: 18", textColor: .specialLine, font: .robotoMedium14)
    private let nowLabel = UILabel(text: "Now: 24", textColor: .specialLine, font: .robotoMedium14)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(differenceLabel)
        addSubview(workoutNameLabel)
        stackView = UIStackView(arrangedSubviews: [beforeLabel, nowLabel], axis: .horizontal, spacing: 10)
        addSubview(stackView)
        addSubview(separator)
        backgroundColor = .clear
    }

    public func setCells(model: DifferenceWorkout) {
        workoutNameLabel.text = model.name
        beforeLabel.text = "Before: \(model.firstReps)"
        nowLabel.text = "Now: \(model.lastReps)"
        let difference = model.lastReps - model.firstReps
        differenceLabel.text = "\(difference)"

        switch difference {
        case ..<0: differenceLabel.textColor = .specialGreen
        case 1...: differenceLabel.textColor = .specialYellow
        default:
            differenceLabel.textColor = .specialGray
        }
    }
}

extension StatisticsTableViewCell {

    private func setConstraints() {

        NSLayoutConstraint.activate([
            //differenceLabel
            differenceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            differenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            differenceLabel.widthAnchor.constraint(equalToConstant: 50),

            //nameLabel
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            workoutNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            workoutNameLabel.trailingAnchor.constraint(equalTo: differenceLabel.leadingAnchor, constant: -20),

            //stackView
            stackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 3),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),

            //separator
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])

    }

}
