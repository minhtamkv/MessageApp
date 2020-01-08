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
import Then

private struct CheckCharater {
    let inputEmpty: Int = 1
}

class LoginViewController: UIViewController {

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
            self.loginAccess()
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
            self.loginAccess()
        case .invalid:
            self.showAlert(message: "Vui lòng điền Mật khẩu", title: "Đồng ý")
        }
    }
    
    func loginAccess() {
        let groupViewController = GroupViewController(nibName: "GroupViewController", bundle: nil)
        groupViewController.modalPresentationStyle = .fullScreen
        let transition = CATransition().then {
            $0.duration = 0.5
            $0.type = CATransitionType.push
            $0.subtype = CATransitionSubtype.fromLeft
            $0.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        }
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.present(groupViewController, animated: false)
    }
    
    @IBAction func handleRegisterButton(_ sender: UIButton) {
        let registerViewController = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        registerViewController.modalPresentationStyle = .fullScreen
        let transition = CATransition().then {
            $0.duration = 0.5
            $0.type = CATransitionType.push
            $0.subtype = CATransitionSubtype.fromLeft
            $0.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        }
        view.window?.layer.add(transition, forKey: kCATransition)
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

