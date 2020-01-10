//
//  ProfileViewController.swift
//  Message
//
//  Created by Minh Tâm on 1/10/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//
import UIKit
import Firebase
import SDWebImage

enum OpenSourceFile {
    case camera
    case gallary
}

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var maleButton: UIButton!
    @IBOutlet private weak var femaleButton: UIButton!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var dateOfBirthTextField: UITextField!
    @IBOutlet private weak var numberPhoneTextField: UITextField!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    private var currentPhone = ""
    private var currentDate = ""
    private var isSave = false
    private var genderUser: String?
    private var isChosen : String = "nil"
    private let datePicker = UIDatePicker()
    private var picker = UIImagePickerController()
    private var alert = UIAlertController(title: "Chọn hình ảnh", message: nil, preferredStyle: .actionSheet)
    private let database = Firestore.firestore()
    private var currentUser = Auth.auth().currentUser
    private let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configAlert()
        fetchUser()
    }
    
    func configView() {
        dateOfBirthTextField.isUserInteractionEnabled = false
        numberPhoneTextField.isUserInteractionEnabled = false
        
        picker.delegate = self
    }
    
    func configAlert() {
        alert.addAction(UIAlertAction(title: "Máy ảnh", style: .default) { [weak self] _ in
            self?.openFile(openSourceFile: OpenSourceFile.camera)
        })
        
        alert.addAction(UIAlertAction(title: "Thư viện", style: .default) { [weak self] _ in
            self?.openFile(openSourceFile: OpenSourceFile.gallary)
        })

        alert.addAction(UIAlertAction.init(title: "Huỷ", style: .cancel, handler: nil))
    }
    
    func openFile(openSourceFile: OpenSourceFile){
        switch openSourceFile {
        case .camera:
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            } else {
                showAlert(message: "Thư viện không khả dụng", title: "Đồng ý")
            }
        case .gallary:
            if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            } else {
                showAlert(message: "Thư viện không khả dụng", title: "Đồng ý")
            }
        }
    }
        
    func fetchUser() {
        userRepository.fetchCurrentUser() { [weak self] result, error in
            if error != nil {
                self?.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
            } else {
                self?.setupProfileView(user: result ?? User(userName: "", image: "", email: "", uid: "", senderType: .unknown, gender: .unknown, roomArray: [""], numberPhone: ""))
            }
        }
    }
    
    func setupProfileView(user: User) {
        self.userNameLabel.text = user.userName
        self.emailLabel.text = user.email
        
        let url = URL(string: user.image)
        self.avatarImageView.sd_setImage(with: url, completed: nil)
    }

    @IBAction func maleTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func femaleTapped(_ sender: UIButton) {
    }
    
    @IBAction func handleBackButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func handleLogoutButton(_ sender: UIButton) {
    }
    

    @IBAction func avatarTapped(_ sender: UIButton) {
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.avatarImageView.image = image
        userRepository.uploadAvatarToFirebase(image: avatarImageView.image)
    }
}
