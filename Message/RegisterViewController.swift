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
    let numberOfValidate = 3
}

final class RegisterViewController: UIViewController {    

    @IBOutlet private weak var fullnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    private let database = Firestore.firestore()
    private let userRepository = UserRepository()
    private var validateSuccessEmail = false
    private var validateSuccessPassword = false
    private var validateConfirmPassword = false
    
           
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
            validateSuccessEmail = true
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch resultPassword {
        case .valid:
            validateSuccessPassword = true
        case .invalid:
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        }
        
        switch validatePassword {
        case true:
            validateConfirmPassword = true
        case false:
            self.showAlert(message: "Mật khẩu không xác định", title: "Đồng ý")
        }
        
        if validateSuccessEmail == true && validateSuccessPassword == true && validateConfirmPassword == true {
            userRepository.register(user: username, password: password, fullname: fullname) { [weak self] result, error in
                guard let error = error else { return }
                print("\(error)")
            }
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
