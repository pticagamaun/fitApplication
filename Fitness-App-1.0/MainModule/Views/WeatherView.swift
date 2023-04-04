//
//  WeatherView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

class WeatherView: UIView {
    
    private let weatherStatusLabel = UILabel(text: "Солнечно",
                                     textColor: .specialGray,
                                     font: .robotoMedium18)
    private let weatherDescriptionLabel = UILabel(text: "Хорошая погода, чтобы позаниматься на улице",
                                           textColor: .specialLightGray,
                                           font: .robotoMedium14)
    private let weatherImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sun")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
        
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        addShadowOnView()
    }
    
    public func updateImage(data: Data) {
        guard let image = UIImage(data: data) else {return}
        weatherImageView.image = image
    }
    
    public func updateLabels(model: WeatherModel) {
        weatherStatusLabel.text = model.weather[0].myDescription + " \(model.main.tempatureCelcius)°C"
        switch model.weather[0].weatherDescription {
        case "broken clouds": weatherDescriptionLabel.text = "Лучше остаться дома и позаниматься"
        default:
            weatherDescriptionLabel.text = "No Data"
        }
    }
}

extension WeatherView {
    
    private func setConstraints() {
        
        addSubview(weatherImageView)
        addSubview(weatherStatusLabel)
        addSubview(weatherDescriptionLabel)
        
        NSLayoutConstraint.activate([
            //weatherImageView
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            weatherImageView.heightAnchor.constraint(equalToConstant: 65),
            weatherImageView.widthAnchor.constraint(equalToConstant: 65),
            
            //weatherStatusLabel
            weatherStatusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherStatusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherStatusLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor, constant: -10),
            
            //weatherDescriptionLabel
            weatherDescriptionLabel.topAnchor.constraint(equalTo: weatherStatusLabel.bottomAnchor, constant: 3),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor, constant: -10)
        ])
        
    }
    
}

