//
//  Notification.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/18/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Notification {
    var notificationLabel: String = ""
    var image: UIImage = UIImage()
    
    init(notificationLabel: String, image:UIImage) {
        self.notificationLabel = notificationLabel
        self.image = image
    }
    
    init?(snapshot: DataSnapshot) {
        print(snapshot.value)
        guard let dict = snapshot.value as? [String: Any],
        let betKey = dict["betKey"] as? String,
        let isBet = dict["isBet"] as? Int,
        let isFollow = dict["isFollow"] as? Int,
        let otherChosenBet = dict["otherChosenBet"] as? Int,
        let otherUsername = dict["otherUsername"] as? String
            else {return nil}
        
        if isBet == 1 {
            BetService.getInfoOfBet(betKey: betKey) { (betQuestion, typeOfGame, firstBetOption, secondBetOption, isActive, rightAnswer, magoo, createBet) in
                
                let chosenBet = self.chosenOption(chosenOption: otherChosenBet, firstBetOption: firstBetOption, secondBetOption: secondBetOption)
                
                self.notificationLabel = "\(otherUsername) made a new bet with you: '\(betQuestion). He bet \(chosenBet). Click here to bet against him"
                
                self.image = #imageLiteral(resourceName: "Single Arrow")
            }
        }
    }
    
    func chosenOption(chosenOption: Int, firstBetOption: String, secondBetOption: String) -> String {
        if chosenOption == 0 {
            return firstBetOption
        } else {
            return secondBetOption
        }
    }
}
