//
//  RegisterVC.swift
//  Message
//
//  Created by Minh Tâm on 12/5/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Validator

private struct Constants {
    let inputEmpty: Int = 1
}

class RegisterViewController: UIViewController {

    @IBOutlet private weak var fullnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var indicator: UIView!
    
    let db = Firestore.firestore()
    let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func handleCreateAccount(_ sender: UIButton) {
        guard let username = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let fullname = fullnameTextField.text else { return }
        let validatePassword = password == confirmPassword ? true : false
        let minLengthRule = ValidationRuleLength(min: Constants().inputEmpty, error: CustomValidationError("error"))
        let resultEmail = emailTextField.validate(rule: minLengthRule)
        let resultPassword = passwordTextField.validate(rule: minLengthRule)
        
        switch resultEmail {
        case .valid:
            userRepository.register(user: username, password: password, fullname: fullname, completion: nil)
            self.dismiss(animated: true, completion: nil)
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch resultPassword {
        case .valid:
            userRepository.register(user: username, password: password, fullname: fullname, completion: nil)
            self.dismiss(animated: true, completion: nil)
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch validatePassword {
        case true:
            userRepository.register(user: username, password: password, fullname: fullname, completion: nil)
            self.dismiss(animated: true, completion: nil)
        case false:
            self.showAlert(message: "Mật khẩu không xác định", title: "Đồng ý")
        }
    }
    @IBAction func handleBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
}
