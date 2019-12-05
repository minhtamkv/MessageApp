//
//  RegisterVC.swift
//  Message
//
//  Created by Minh Tâm on 12/5/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import Validator

private struct CheckCharacter {
    let inputEmpty: Int = 1
}

class RegisterVC: UIViewController {

    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
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
        let minLengthRule = ValidationRuleLength(min: CheckCharacter().inputEmpty, error: ValidatorError("error"))
        let resultEmail = emailTextField.validate(rule: minLengthRule)
        let resultPassword = passwordTextField.validate(rule: minLengthRule)
        
        switch resultEmail {
        case .valid:
            userRepository.register(user: username, password: password, fullname: fullname, completion: nil)
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch resultPassword {
        case .valid:
            userRepository.register(user: username, password: password, fullname: fullname, completion: nil)
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch validatePassword {
        case true:
            userRepository.register(user: username, password: password, fullname: fullname, completion: nil)
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
