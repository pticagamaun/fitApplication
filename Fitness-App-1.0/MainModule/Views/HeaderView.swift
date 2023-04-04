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
    
    public let userPhotoImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        image.layer.cornerRadius = 50
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    public let nameLabel = UILabel(text: "Your Name",
                                    textColor: .specialGray,
                                    font: .robotoBold24, minimumScaleFactor: 0.5)
    
    lazy var addWorkoutButton = AddWorkoutButton(font: .robotoMedium12)
    private let calendarView = CalendarView()
    public let weatherView = WeatherView()
    weak var headerViewDelegate: HeaderViewProtocol?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConstraints()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
        addWorkoutButton.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addWorkoutButtonTapped() {
        headerViewDelegate?.pressButton()
    }
    
    //MARK: - Public Funcs
    public func setDelegateCalendarProtocol(_ delegate: CalendarCollectionProtocol) {
        calendarView.setDelegate(delegate)
    }
}

//MARK: - Constraints
extension HeaderView {
    
    private func setConstraints() {
        
        addSubview(calendarView)
        addSubview(userPhotoImageView)
        addSubview(nameLabel)
        addSubview(addWorkoutButton)
        addSubview(weatherView)

        
        NSLayoutConstraint.activate([
            //userPhoto
            userPhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            //calendarView
            calendarView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            calendarView.heightAnchor.constraint(equalToConstant: 70),
            
            //nameLabel
            nameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            //addWorkoutButton
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
            
            //weatherView
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            weatherView.heightAnchor.constraint(equalToConstant: 80),
        ])
        
    }
    
}
