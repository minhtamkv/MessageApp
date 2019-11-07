//
//  BaseVC.swift
//  Message
//
//  Created by Minh Tâm on 11/7/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import UIKit

class BaseVC : UIViewController, BaseView {
    
    var table: UITableView?
    var refreshTableView: UITableView?
    var refreshControl: UIRefreshControl?
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
    }
    
    func setRefreshableView(_ view: UITableView) {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = AppColor.COLOR_ACCENT
        self.refreshControl!.addTarget(self, action: #selector(BaseVC.onPullRefresh), for: UIControl.Event.valueChanged)
        
        self.refreshTableView = view
        view.addSubview(refreshControl!)
    }
    
    dynamic open func onPullRefresh() {
        self.refreshControl?.endRefreshing()
    }
    
    dynamic func pullRefreshed() {
        self.refreshControl?.endRefreshing()
    }
    
    
    func reload() {
        DispatchQueue.main.async {
            self.refreshTableView?.reloadData()
        }
    }
    
    
    func reloadTableView() {
        if self.table != nil {
            DispatchQueue.main.async {
                self.table?.reloadData()
            }
        }
    }
    
    func showAlert(message : String , title : String){
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showLoading(){
        activityIndicator.startAnimating()
    }
    
    func dismissLoading(){
        activityIndicator.stopAnimating()
    }
    
    
}
