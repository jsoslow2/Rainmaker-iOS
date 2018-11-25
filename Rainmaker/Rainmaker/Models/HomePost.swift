//
//  HomePost.swift
//  Rainmaker
//
//  Created by Eugene Enclona on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot


class HomePost {
    
    var friendsKey: String
    var chosenBet: Int // 0 is left, 1 is right
    var betKey: String
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let friendsKey = dict["friendsKey"] as? String,
            let chosenBet = dict["chosenBet"] as? Int,
            let betKey = dict["betKey"] as? String
            else { return nil }
        
        self.friendsKey = friendsKey
        self.chosenBet = chosenBet
        self.betKey = betKey
    }
    
}
