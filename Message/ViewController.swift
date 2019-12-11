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
    let inputEmpty: Int = 1
    let emailMaxLength: Int = 32
    let passwordMinLength: Int = 7
}

class ViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var checkLoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let defaults = UserDefaults.standard
    let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
    }
    
    func configViews() {
        indicator.isHidden = true
    }
    
    @IBAction func handleLoginButton(_ sender: UIButton) {
        guard let username = emailTextField.text,
            let password = passwordTextField.text else { return }
        let minLengthRule = ValidationRuleLength(min: CheckCharater().inputEmpty, error: CustomValidationError("error"))
        let resultEmail = username.validate(rule: minLengthRule)
        let resultPass = password.validate(rule: minLengthRule)

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
        
        switch resultPass {
        case .valid:
            userRepository.login(user: username, password: password) { _, error in
                if error != nil {
                    self.stopIndicator()
                    self.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                }
            }
        case .invalid:
            self.showAlert(message: "Vui lòng điền Mật khẩu", title: "Đồng ý")
        }
        
        let minLengthRulePassword = ValidationRuleLength(min: CheckCharater().passwordMinLength, error:  CustomValidationError("error"))
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
        
        let maxLengthRule = ValidationRuleLength(max: 5, error:  CustomValidationError("error"))
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
    
    @IBAction func handleRegisterButton(_ sender: UIButton) {
        let registerViewController = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        registerViewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(registerViewController, animated: false)
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

