//
//  HeaderView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//
import UIKit

protocol HeaderViewProtocol: AnyObject {
    func pressButton()
}

final class HeaderView: UIView {
    
    let userPhotoImageView = UserPhotoImageView(frame: .zero)
    let nameLabel = UILabel(text: "Your Name",
                                    textColor: .specialGray,
                                    font: .robotoBold24, minimumScaleFactor: 0.5)
    lazy var addWorkoutButton = AddWorkoutButton(font: .robotoMedium12,
                                                 target: self,
                                                 action: #selector(addWorkoutButtonTapped))
    private let calendarView = CalendarView()
    public let weatherView = WeatherView()
    weak var headerViewDelegate: HeaderViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .none
        addViews([calendarView, userPhotoImageView, nameLabel, addWorkoutButton, weatherView])
    }
    
    @objc private func addWorkoutButtonTapped() {
        headerViewDelegate?.pressButton()
    }
    
    public func setDelegateCalendarProtocol(_ delegate: CalendarCollectionProtocol) {
        calendarView.setDelegate(delegate)
    }
}

//MARK: - Constraints
extension HeaderView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),

            calendarView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            calendarView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),

            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            weatherView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
}
