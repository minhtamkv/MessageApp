//
//  MessageViewController.swift
//  Message
//
//  Created by Minh Tâm on 1/10/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import Then
import Reusable

private enum Constants {
    static let numberOfSections = 1
}

private enum FirebaseConstant {
    static let message = "message"
    static let msg = "msg"
    static let room = "room"
    static let users = "users"
    static let uid = "uid"
    static let time = "time"
    static let image = "image"
}


final class MessageViewController: UIViewController, StoryboardSceneBased {
        
    @IBOutlet private weak var nameGroupLabel: UILabel!
    @IBOutlet private weak var mesasgeTableView: UITableView!
    @IBOutlet private weak var inputTextField: UITextView!
    
    var idRoom: String?
    var groupName: String = ""
    private var messages = [Message]() {
        didSet {
            mesasgeTableView.reloadData()
            mesasgeTableView.scrollToBottom()
        }
    }
    private let currentUser = Auth.auth().currentUser
    var length = 0
    var pickerMessage = UIImagePickerController()
    var pickerGroup = UIImagePickerController()
    var alertMessage = UIAlertController(title: "Chọn hình ảnh", message: nil, preferredStyle: .actionSheet)
    var alertGroup = UIAlertController(title: "Chọn hình ảnh", message: nil, preferredStyle: .actionSheet)
    var titleGroup: String = ""
    private let database = Firestore.firestore()
    private let messageRepository = MessageRepository()
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configView()
        fetchMessage()
    }
    
    func configView() {
        nameGroupLabel.text = groupName
    }
    
    func configTableView() {
        mesasgeTableView.do {
            $0.register(cellType: SendTextTableViewCell.self)
            $0.register(cellType: ReceiveTextTableViewCell.self)
            $0.register(cellType: SendImageTableViewCell.self)
            $0.register(cellType: ReceiveImageTableViewCell.self)
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func fetchMessage() {
        guard let idRoom = self.idRoom else { return }
        messageRepository.getMessage(idRoom: idRoom) { result, error in
            self.messages = result ?? []
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func uploadImageMessage(image :UIImage){
        guard let `currentUser` = self.currentUser else { return }
        let time: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        var heightImage: CGFloat?
        var widthImage: CGFloat?
        let ratio = image.size.width/image.size.height
        var newImage: UIImage?
        if image.size.width > 200 && image.size.width > image.size.height {
            newImage = resizeImage(image: image, targetSize: CGSize(width: 200, height: 200/ratio))
            heightImage = newImage?.size.height
            widthImage = newImage?.size.width
        } else if image.size.height > 200 && image.size.height > image.size.width {
            newImage = resizeImage(image: image, targetSize: CGSize(width: 200 * ratio, height: 200))
            heightImage = newImage?.size.height
            widthImage = newImage?.size.width
        } else {
            newImage = image
            heightImage = image.size.height
            widthImage = image.size.width
        }
        guard let idRoom = self.idRoom else {return}
        let dataMessage : [String : Any] = [
            "content" : "",
            "fromUser" : currentUser.uid,
            "time" : time,
            "toRoom": idRoom,
            "image" : "",
            "height" : heightImage,
            "width" : widthImage
        ]
        database
            .collection(FirebaseConstant.room)
            .document(idRoom)
            .setData(["time" : time], merge: true)
        
        let refer = self.database
            .collection(FirebaseConstant.message)
            .document(idRoom)
            .collection(FirebaseConstant.msg)
            .addDocument(data: dataMessage)
        let idImageMessenger = refer.documentID
        var dataImage = Data()
        if let data = newImage?.pngData(){
            dataImage = data
        }
        else if let data = newImage?.jpegData(compressionQuality: 1) {
            dataImage = data
        }
        
        let filePath = "images"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let storageRef = Storage.storage().reference()
        let ref = storageRef.child("\(filePath)/\(idImageMessenger).jpeg")
        ref.putData(dataImage, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                ref.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        guard let `url` = url else { return }
                        let timeSending: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                        let dataMessage : [String : Any] = [
                            "time" : timeSending,
                            "image" : url.absoluteString
                        ]
                        self.database
                            .collection(FirebaseConstant.message)
                            .document(idRoom)
                            .collection(FirebaseConstant.msg)
                            .document(idImageMessenger)
                            .setData(dataMessage, merge: true)
                    }
                })
            }
        }
        
    }

    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        guard let currentUser = self.currentUser, let message = inputTextField.text else { return }
        guard let idRoom = idRoom else { return }
        let timeSending: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let dataMessage : [String : Any] = [
            "content" : message,
            "fromUser" : currentUser.uid,
            "time" : timeSending,
            "toRoom": idRoom,
            "image" : ""
        ]
        database.collection("message").document(idRoom).collection("msg").addDocument(data: dataMessage)
        inputTextField.text = ""
        self.database.collection("room").document(idRoom).setData(["time" : timeSending], merge: true)
    }
    
    @IBAction func attackButton(_ sender: UIButton) {
        present(alertMessage, animated: true, completion: nil)
    }
    
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        if message.uidUser == currentUser?.uid && message.image == "" {
            let sendTextCell = mesasgeTableView.dequeueReusableCell(withIdentifier: "SendTextTableViewCell") as! SendTextTableViewCell
            sendTextCell.setupCell(data: message)
            return sendTextCell
        } else if message.uidUser == currentUser?.uid && message.image != "" {
            let sendImageCell = mesasgeTableView.dequeueReusableCell(withIdentifier: "SendImageTableViewCell") as! SendImageTableViewCell
            sendImageCell.setupCell(data: message)
            
            return sendImageCell
        } else if message.uidUser != currentUser?.uid && message.image != "" {
            let receiveImageCell = mesasgeTableView.dequeueReusableCell(withIdentifier: "ReceiveImageTableViewCell") as! ReceiveImageTableViewCell
                
            receiveImageCell.setupCell(data: message)
            return receiveImageCell
        } else {
            let receiveTextCell = mesasgeTableView.dequeueReusableCell(withIdentifier: "ReceiveTextTableViewCell") as! ReceiveTextTableViewCell
            receiveTextCell.setupCell(data: message)
            return receiveTextCell
        }
    }
}

extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        uploadImageMessage(image: image)
    }
}
