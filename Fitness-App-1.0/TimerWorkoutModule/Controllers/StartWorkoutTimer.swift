//
//  StartWorkoutTimer.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 15.11.2022.
//

import UIKit

class StartWorkoutTimer: UIViewController {

    private let titleLabel = UILabel(text: "START WORKOUT", textColor: .specialBlack, font: .robotoBold24)
    private let closeButton = CloseButton(type: .system)
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ellipse")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let timerLabel = UILabel(text: "01:30", textColor: .specialGray, font: .robotoBold48)
    private let parametersView = TimerWorkoutParameters()
    private let finishButton = GreenButton(text: "FINISH")
    private var workoutModel = WorkoutModel()
    private let customAlert = CustomAlert()
    private let shapeLayer = CAShapeLayer()
    private var timer = Timer()
    private var durationTimer = 0
    private var numberOfSet = 0
    private var gesture = UITapGestureRecognizer()
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        animationCircle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        addTargets()
        addGesture()
        setWorkoutParameters()
    }
    
    //MARK: - Private Funcs
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.backgroundColor = .specialBackground
        view.addSubview(imageView)
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        view.addSubview(parametersView)
        parametersView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        view.addSubview(finishButton)
        parametersView.timerWorkoutParametersDelegate = self
    }
    
    private func addTargets() {
        closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishButtonTap), for: .touchUpInside)
    }
    
    @objc private func closeButtonTap() {
        timer.invalidate()
        dismiss(animated: true)
    }
    
    @objc private func finishButtonTap() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            secondAlert(title: "Warning!", message: "You really want to finished your workout?") {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func addGesture() {
        gesture = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(gesture)
    }
    
    @objc private func startTimer() {
        parametersView.buttonsIsEnable(false)
        
        if numberOfSet == workoutModel.workoutSets {
            simpleAlert(title: "Warning!", message: "You really want to finished your workout?")
        } else {
            basicAnimnation()
            gesture.isEnabled = false
            timer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(timerTap),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
    
    @objc private func timerTap() {
        durationTimer -= 1
        print(durationTimer)
        
        if durationTimer == 0 {
            timer.invalidate()
            gesture.isEnabled = true
            durationTimer = workoutModel.workoutTimer
            numberOfSet += 1
            parametersView.refreshLabels(model: self.workoutModel, numberOfSet: numberOfSet)
            parametersView.buttonsIsEnable(true)
        }
        
        let(min, sec) = durationTimer.convertSecond()
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
    }
    
    private func setWorkoutParameters() {
        let(min, sec) = workoutModel.workoutTimer.convertSecond()
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
        durationTimer = workoutModel.workoutTimer
    }
    
    //MARK: - Public Funcs
    public func setModel(_ model: WorkoutModel) {
        workoutModel = model
    }
}


//MARK: - RepsWorkoutParametersProtocol
extension StartWorkoutTimer: TimerWorkoutParametersProtocol {
    func editingButtonTapped() {
        customAlert.presentCustomAlert(viewController: self, repsOrTimer: "Timer") { [weak self] setsNumber, timerNumber in
            guard let self = self else {return}
            if setsNumber != "" && timerNumber != "" {
                guard let numberOfSets = Int(setsNumber),
                      let numberOfTimer = Int(timerNumber) else { return }
                RealmManager.shared.updateTimerSetsWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               timer: numberOfTimer)
                let(min, sec) = numberOfTimer.convertSecond()
                self.timerLabel.text = "\(min):\(sec.setZeroForSecond())"
                self.parametersView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
        }
    }
    
    func nextSetButtonTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            parametersView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        } else {
            secondAlert(title: "Error", message: "Want to finish your workout?") {
                self.finishButtonTap()
            }
        }
    }
}

//MARK: - Animation
extension StartWorkoutTimer {
    
    private func animationCircle() {
        let center = CGPoint(x: imageView.frame.width / 2,
                             y: imageView.frame.height / 2) // задаем центр
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: 135,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: false)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        imageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimnation() {
        let basicAnimnation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimnation.toValue = 0
        basicAnimnation.duration = CFTimeInterval(durationTimer)
        basicAnimnation.fillMode = .forwards
        basicAnimnation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimnation, forKey: "basicAnimnation")
    }
}


//MARK: - Constraints
extension StartWorkoutTimer {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            //closeButton
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            //imageView
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            //timerLabel
            timerLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 40),
            timerLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -40),
            timerLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            //parametersView
            parametersView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            parametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            parametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            parametersView.heightAnchor.constraint(equalToConstant: 265),
            
            //finishButton
            finishButton.topAnchor.constraint(equalTo: parametersView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}

