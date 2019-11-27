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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.isHidden = true
    }

    
    @IBAction func clickLogin(_ sender: Any) {
        guard let username = emailTextField.text, let password = passwordTextField.text else {return}
        if username.count < 1 {
            stopIndicator()
            self.showAlert(message: "Vui lòng điền Email", title: "Đồng ý")
        } else if username.count > 32 {
            stopIndicator()
            self.showAlert(message: "Email chỉ được phép có tối đa 32 ký tự  Vui lòng thử lại", title: "Đồng ý")
        } else if password.count < 1 {
            stopIndicator()
            self.showAlert(message: "Vui lòng điền mật khẩu", title: "Đồng ý")
        } else if ((password.count < 8) || (password.count > 64)) {
            stopIndicator()
            self.showAlert(message: "Mật khẩu phải có ít nhất 8 ký tự và có tối đa 64 ký tự", title: "Đồng ý")
        } else {
            UserRepository.shared.login(user: username, password: password) {(result, error) in
                if error != nil {
                    self.stopIndicator()
                    self.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
                } else {
                self.stopIndicator()
                self.defaults.set(username, forKey: "username")
                self.defaults.set(password, forKey: "password")
                self.defaults.set(true, forKey: "islogin")
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

