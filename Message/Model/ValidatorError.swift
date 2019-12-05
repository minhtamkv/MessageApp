//
//  ValidatorError.swift
//  Message
//
//  Created by Minh Tâm on 12/5/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import Validator

struct ValidatorError: ValidationError {

    let message: String
    
    public init(_ message: String) {
        
        self.message = message
    }
}
