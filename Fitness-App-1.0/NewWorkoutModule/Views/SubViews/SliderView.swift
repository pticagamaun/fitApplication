//
//  SliderView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

protocol SliderViewProtocol: AnyObject {
    func changeValue(type: SliderType, value: Int)
}

class SliderView: UIView {
    
    private let nameLabel = UILabel(text: "Name",
                                    textColor: .specialGray,
                                    font: .robotoMedium18)
    private let numberLabel = UILabel(text: "0",
                                      textColor: .specialGray,
                                      font: .robotoMedium24)
    private lazy var slider = GreenSlider()
    private var stackView = UIStackView()
    public var sliderType: SliderType?
    public var isActive: Bool = true {
        didSet {
            if isActive {
                nameLabel.alpha = 1
                numberLabel.alpha = 1
                slider.alpha = 1
            } else {
                nameLabel.alpha = 0.5
                numberLabel.alpha = 0.5
                slider.alpha = 0.5
                numberLabel.text = "0"
                slider.value = 0
            }
        }
    }
    weak var delegate: SliderViewProtocol?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(name: String, minValue: Float, maxValue: Float, type: SliderType) {
        self.init(frame: .zero)
        nameLabel.text = name
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        sliderType = type
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderChanded), for: .valueChanged)
        let labelsStackView = UIStackView(arrangedSubviews: [nameLabel, numberLabel], axis: .horizontal, spacing: 10)
        labelsStackView.distribution = .equalSpacing
        stackView = UIStackView(arrangedSubviews: [labelsStackView, slider], axis: .vertical, spacing: 10)
        addSubview(stackView)
    }
    
    @objc private func sliderChanded() {
        let intSliderValue = Int(slider.value)
        numberLabel.text = sliderType == .timer ? intSliderValue.getMinutesAndSeconds() : String(intSliderValue)
        guard let type = sliderType else { return  }
        delegate?.changeValue(type: type, value: intSliderValue)
    }
    
    //MARK: - Public Funcs
    public func resetSlider() {
        numberLabel.text = ""
        slider.value = 0
        isActive = true
    }
}



//MARK: - Set Constraints

extension SliderView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //stackView
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}

