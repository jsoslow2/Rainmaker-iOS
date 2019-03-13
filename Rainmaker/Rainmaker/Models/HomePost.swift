//
//  HomePost.swift
//  Rainmaker
//
//  Created by Jack Soslow on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot


class HomePost {
    
    var chosenBet: Int // 0 is left, 1 is right
    var betKey: String
    var image: UIImage
    var betQuestion: String?
    var typeOfGame: String?
    var UID: String
    var username: String?
    var firstOption: String?
    var secondOption: String?
    var isActive : Int?
    var rightAnswer : Int?
    var otherUsername : String?
    var createBet : Int?
    
    init(chosenBet: Int, betKey: String, image: UIImage, betQuestion: String?, typeOfGame: String?, UID: String, username: String, firstOption: String, secondOption: String) {
        self.chosenBet = chosenBet
        self.betKey = betKey
        self.image = #imageLiteral(resourceName: "default copy")
        self.betQuestion = betQuestion
        self.typeOfGame = typeOfGame
        self.UID = UID
        self.username = username
        self.firstOption = firstOption
        self.secondOption = secondOption
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let chosenBet = dict["chosenBet"] as? Int,
            let UID = dict["uidOfBettor"] as? String,
            let betKey = dict["betKey"] as? String
            else { return nil }
        
        self.chosenBet = chosenBet
        self.betKey = betKey
        self.UID = UID
        self.image = #imageLiteral(resourceName: "default copy")
    }
    
}
