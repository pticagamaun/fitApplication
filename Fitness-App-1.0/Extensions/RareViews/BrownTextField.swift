//
//  BrownTextField.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

protocol BrownTextFieldProtocol: AnyObject {
    func textChange(shouldChangeCharactersIn range: NSRange, replacementString string: String)
    func tapClear()
}

class BrownTextField: UITextField {
    
    weak var brownTextFieldDelegate: BrownTextFieldProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.borderStyle = .none
        self.layer.cornerRadius = 10
        self.backgroundColor = .specialLightBrown
        self.textColor = .specialGray
        self.font = .robotoBold20
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.leftViewMode = .always
        self.clearButtonMode = .always
        self.returnKeyType = .done
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension BrownTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        brownTextFieldDelegate?.textChange(shouldChangeCharactersIn: range, replacementString: string)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        brownTextFieldDelegate?.tapClear()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        true
    }
}
