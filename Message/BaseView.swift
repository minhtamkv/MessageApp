//
//  BaseView.swift
//  Message
//
//  Created by Minh Tâm on 11/7/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation

@objc protocol BaseView {
    
    @objc optional func pullRefreshed()
    
    @objc optional func onPullRefresh()
}
