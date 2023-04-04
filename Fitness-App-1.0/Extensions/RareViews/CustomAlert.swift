//
//  CustomAlert.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 19.11.2022.
//

import UIKit

class CustomAlert: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private var mainView: UIView?
    
    private let setsTextField = BrownTextField()
    private let repsTimerTextField = BrownTextField()
    
    private var buttomAction: ((String, String) -> Void)?
    
    func presentCustomAlert(viewController: UIViewController,
                            repsOrTimer: String,
                            completion: @escaping (String, String) -> Void) {
        registerForKeyboardNotification()
        
        guard let parentView = viewController.view else {return}
        mainView = parentView
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect.init(x: 40,
                                      y: -450,
                                      width: parentView.frame.width - 80,
                                      height: 450)
        scrollView.addSubview(alertView)
        let sportsmanImageView = UIImageView(frame: CGRect.init(
            x: (alertView.frame.width - alertView.frame.height * 0.4) / 2,
            y: 30,
            width: alertView.frame.height * 0.4,
            height: alertView.frame.height * 0.4))
        sportsmanImageView.image = UIImage(named: "sportsman")
        sportsmanImageView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmanImageView)
        let editingLabel = UILabel(text: "Editing", textColor: .specialBlack, font: .robotoMedium22)
        editingLabel.frame = CGRect.init(x: 10,
                                         y: alertView.frame.height * 0.4 + 50,
                                         width: alertView.frame.width - 20,
                                         height: 25)
        editingLabel.textAlignment = .center
        editingLabel.translatesAutoresizingMaskIntoConstraints = true
        alertView.addSubview(editingLabel)
        
        let setsLabel = UILabel(text: "Sets", textColor: .specialLine, font: .robotoMedium14)
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect.init(x: 30,
                                      y: editingLabel.frame.maxY + 10,
                                      width: alertView.frame.width - 60,
                                      height: 20)
        alertView.addSubview(setsLabel)
        
        setsTextField.frame = CGRect.init(x: 20,
                                          y: setsLabel.frame.maxY,
                                          width: alertView.frame.width - 40,
                                          height: 30)
        setsTextField.translatesAutoresizingMaskIntoConstraints = true
        setsTextField.keyboardType = .numberPad
        alertView.addSubview(setsTextField)
        
        let repsOrTimerLabel = UILabel(text: repsOrTimer, textColor: .specialLine, font: .robotoMedium14)
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect.init(x: 30,
                                             y: setsTextField.frame.maxY + 3,
                                             width: alertView.frame.width - 60,
                                             height: 20)
        alertView.addSubview(repsOrTimerLabel)
        
        repsTimerTextField.frame = CGRect.init(x: 20,
                                               y: repsOrTimerLabel.frame.maxY,
                                               width: alertView.frame.width - 40,
                                               height: 30)
        repsTimerTextField.translatesAutoresizingMaskIntoConstraints = true
        repsTimerTextField.keyboardType = .numberPad
        alertView.addSubview(repsTimerTextField)
        
        lazy var okButton = GreenButton(text: "OK")
        okButton.frame = CGRect.init(x: 50,
                                     y: repsTimerTextField.frame.maxY + 20,
                                     width: alertView.frame.width - 100,
                                     height: 35)
        okButton.translatesAutoresizingMaskIntoConstraints = true
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside )
        alertView.addSubview(okButton)
        
        buttomAction = completion
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { action in
            if action {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func okButtonTapped() {
        
        guard let setsNumber = setsTextField.text,
              let repsNumber = repsTimerTextField.text else { return }
        
        buttomAction?(setsNumber, repsNumber)
        
        guard let targetView = mainView else { return }
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect.init(x: 40,
                                               y: targetView.frame.height,
                                               width: targetView.frame.width - 80,
                                               height: 450)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0
            } completion: { action in
                if action {
                    self.alertView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.scrollView.removeFromSuperview()
                    self.setsTextField.text = ""
                    self.repsTimerTextField.text = ""
                    self.removeForKeyboardNotification()
                }
            }
        }
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyboardShow() {
        scrollView.contentOffset = .init(x: 0, y: 100)
    }
    
    @objc private func keyboardHide() {
        scrollView.contentOffset = .zero
    }
}
