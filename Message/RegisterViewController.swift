//
//  ViewController.swift
//  Message
//
//  Created by Minh Tâm on 1/8/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Validator
import Then
import Reusable

private struct Constants {
    let inputEmpty = 1
}

final class RegisterViewController: UIViewController {    

    @IBOutlet private weak var fullnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    let database = Firestore.firestore()
    let userRepository = UserRepository()
           
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            userRepository.register(user: username, password: password, fullname: fullname) { result, error in
                guard let error = error else { return }
                print("\(error)")
            }
            self.dismiss(animated: false, completion: nil)
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch resultPassword {
        case .valid:
            userRepository.register(user: username, password: password, fullname: fullname) { result, error in
                guard let error = error else { return }
                print("\(error)")
            }
            self.dismiss(animated: false, completion: nil)
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch validatePassword {
        case true:
            userRepository.register(user: username, password: password, fullname: fullname) { result, error in
                guard let error = error else { return }
                print("\(error)")
            }
            self.dismiss(animated: false, completion: nil)
        case false:
            self.showAlert(message: "Mật khẩu không xác định", title: "Đồng ý")
        }
    }
    @IBAction func handleBack(_ sender: UIButton) {
        let transition = CATransition().then {
            $0.duration = 0.5
            $0.type = CATransitionType.push
            $0.subtype = CATransitionSubtype.fromLeft
            $0.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        }
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
