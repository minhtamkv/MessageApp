//
//  ViewController.swift
//  Message
//
//  Created by Minh Tâm on 11/7/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import Validator

private struct CheckCharater {
    let inputEmpty: Int = 0
    let emailMaxLength: Int = 32
    let passwordMinLength: Int = 7
}

class ViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var checkLoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let defaults = UserDefaults.standard
    var validationError: ValidationError?
    let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
    }
    
    func configViews() {
        indicator.isHidden = true
    }
    
    @IBAction func handleLoginButton(_ sender: UIButton) {
        guard let username = emailTextField.text, let password = passwordTextField.text, let validationError = validationError else { return }
        let minLengthRule = ValidationRuleLength(min: CheckCharater().inputEmpty, error: validationError)
        
        let resultEmail = username.validate(rule: minLengthRule)

        switch resultEmail {
        case .valid:
            userRepository.login(user: username, password: password) { _, error in
                if error != nil {
                    self.stopIndicator()
                    self.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                }
            }
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        let minLengthRulePassword = ValidationRuleLength(min: CheckCharater().passwordMinLength, error: validationError)
        let resultPassword = password.validate(rule: minLengthRulePassword)
        
        switch resultPassword {
        case .valid:
            userRepository.login(user: username, password: password) { _, error in
                if error != nil {
                    self.stopIndicator()
                    self.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                }
            }
        case .invalid:
            self.showAlert(message: "Password tối đa 32 ký tự", title: "Đồng ý")
        }
        
        let maxLengthRule = ValidationRuleLength(max: 5, error: validationError)
        let resultEmailMax = username.validate(rule: maxLengthRule)
        
        switch resultEmailMax {
        case .valid:
            userRepository.login(user: username, password: password) { _, error in
                if error != nil {
                    self.stopIndicator()
                    self.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                }
            }
        case .invalid:
            self.showAlert(message: "Email tối đa 32 ký tự", title: "Đồng ý")
        }
    }
    
    func startIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func stopIndicator() {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
}

