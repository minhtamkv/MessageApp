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

class ViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var checkLoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let defaults = UserDefaults.standard
    static let shared = ViewController()
    var inputEmpty: Int = 0
    var emailMaxLength: Int = 32
    var passwordMinLength: Int = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
    }
    
    func configViews() {
        indicator.isHidden = true
    }
    
    @IBAction func handleLoginButton(_ sender: UIButton) {
        guard let username = emailTextField.text, let password = passwordTextField.text else { return }
        switch username.count {
        case inputEmpty:
            stopIndicator()
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        case (inputEmpty + 1)...emailMaxLength:
            stopIndicator()
            UserRepository().login(user: username, password: password) { _, error in
                if error != nil {
                    self.stopIndicator()
                    self.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                }
            }
        default:
            self.showAlert(message: "Email chỉ được phép có tối đa 32 ký tự  Vui lòng thử lại", title: "Đồng ý")
        }
        switch password.count {
        case inputEmpty:
            stopIndicator()
            self.showAlert(message: "Vui lòng điền mật khẩu", title: "Đồng ý")
        case (inputEmpty + 1)...passwordMinLength:
            stopIndicator()
            self.showAlert(message: "Mật khẩu phải có ít nhất 8 ký tự", title: "Đồng ý")
        default:
            UserRepository().login(user: username, password: password) { _, error in
                if error != nil {
                    self.stopIndicator()
                    self.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                }
            }
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

