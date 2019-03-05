//
//  UsableUser.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/6/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class UsableUser { 
    var uid : String
    var username : String
    var currentMoney : Int?
    var profilePic : UIImage?
    var numberOfBets : Int?
    
    init (uid: String, username: String, currentMoney: Int, profilePic: UIImage, numberOfBets : Int) {
        self.uid = uid
        self.username = username
        self.currentMoney = currentMoney
        self.profilePic = profilePic
        self.numberOfBets = numberOfBets
    }
    
    init? (uid: String, snapshot: DataSnapshot) {
        self.uid = uid
        
        let dict = snapshot.value as? [String: Any]
        let username = dict!["username"] as? String
        let currentMoney = dict?["currentMoney"] as? Int
        let numberOfBets = dict?["numberOfBets"] as? Int
        
        self.username = username!
        self.currentMoney = currentMoney
        self.numberOfBets = numberOfBets
        self.profilePic = #imageLiteral(resourceName: "default copy")
    }
}
