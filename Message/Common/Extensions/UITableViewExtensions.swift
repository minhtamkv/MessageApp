//
//  UITableViewExtensions.swift
//  Message
//
//  Created by Minh Tâm on 11/7/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let rowCount = self.numberOfRows(inSection:  self.numberOfSections - 1)
            let indexPath = IndexPath(
                row: rowCount - 1,
                section: self.numberOfSections - 1)
            if rowCount > 0 {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
}

