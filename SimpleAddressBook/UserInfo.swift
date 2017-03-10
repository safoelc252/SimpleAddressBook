//
//  UserInfo.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

class UserInfo {
    //MARK: Properties
    
    var name: String
    var phonenumber: String // temporary type, change as needed
    
    //MARK: Initialization
    init?(name: String, phonenumber: String) {
        
        // Validate name and number, you may add validator method as necessary.
        guard !name.isEmpty else {
            return nil
        }
        
        guard !phonenumber.isEmpty else {
            return nil
        }
        
        self.name = name
        self.phonenumber = phonenumber
    }
}
