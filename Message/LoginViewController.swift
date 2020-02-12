//
//  ViewController.swift
//  Message
//
//  Created by Minh Tâm on 11/7/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import UIKit
import FirebaseAuth
import Validator
import Then
import Reusable

private enum CheckCharater {
    static let inputEmpty = 1
}

final class LoginViewController: UIViewController {

    @IBOutlet weak var checkLoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let defaults = UserDefaults.standard
    private let userRepository = UserRepository()
    private var vatidateSuccessEmail = false
    private var validateSuccessPassword = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
    }
    
    func configViews() {
    }
    
    @IBAction func handleLoginButton(_ sender: UIButton) {
        guard let username = emailTextField.text,
            let password = passwordTextField.text else { return }
        let minLengthRule = ValidationRuleLength(min: CheckCharater.inputEmpty, error: CustomValidationError("error"))
        let resultEmail = username.validate(rule: minLengthRule)
        let resultPass = password.validate(rule: minLengthRule)

        switch resultEmail {
        case .valid:
            vatidateSuccessEmail = true
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch resultPass {
        case .valid:
            validateSuccessPassword = true
        case .invalid:
            self.showAlert(message: "Vui lòng điền Mật khẩu", title: "Đồng ý")
        }
        
        if validateSuccessPassword == true && vatidateSuccessEmail == true {
            userRepository.login(user: username, password: password) { [weak self] _, error in
                if error != nil {
                    self?.stopIndicator()
                    self?.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                } else {
                    self?.loginAccess()
                }
            }
            
        }
    }
    
    func loginAccess() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let groupViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as UIViewController
        self.present(groupViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func handleRegisterButton(_ sender: UIButton) {
        let transition = CATransition().then {
            $0.duration = 0.5
            $0.type = CATransitionType.push
            $0.subtype = CATransitionSubtype.fromRight
            $0.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
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

