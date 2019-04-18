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
    var notificationLabel: NSAttributedString = NSAttributedString(string: "")
    var image: UIImage = UIImage()
    var betKey : String = ""
    
    init(notificationLabel: NSAttributedString, image:UIImage, betKey: String) {
        self.notificationLabel = notificationLabel
        self.image = image
        self.betKey = betKey
    }
    
    init?(snapshot: DataSnapshot, group: DispatchGroup) {
        guard let dict = snapshot.value as? [String: Any],
        let betKey = dict["betKey"] as? String,
        let isBet = dict["isBet"] as? Int,
        let isFollow = dict["isFollow"] as? Int,
        let otherChosenBet = dict["otherChosenBet"] as? Int,
        let otherUsername = dict["otherUsername"] as? String
            else {return nil}
        
        
        
        
        if isBet == 1 {
            group.enter()
            BetService.getInfoOfBet(betKey: betKey)  { (betQuestion, typeOfGame, firstBetOption, secondBetOption, isActive, rightAnswer, magoo, createBet) in
                
                let chosenBet = self.chosenOption(chosenOption: otherChosenBet, firstBetOption: firstBetOption, secondBetOption: secondBetOption)
                
                
                let boldUsername  = otherUsername
                let boldQuestion = betQuestion
                let boldChosenOption = chosenBet
                
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
                
                let attributedUsername = NSMutableAttributedString(string:boldUsername, attributes:attrs)
                let attributedQuestion = NSMutableAttributedString(string:boldQuestion, attributes:attrs)
                let attributedChosenOption = NSMutableAttributedString(string:boldChosenOption, attributes:attrs)
                
                let normalText = " made a new bet with you: '"
                let normalString = NSMutableAttributedString(string:normalText)
                
                let extraText = "' They bet "
                let extraString = NSMutableAttributedString(string: extraText)
                
                let moreText = ". Click the arrow to bet against them"
                let moreString = NSMutableAttributedString(string: moreText)
                
                
                
                attributedUsername.append(normalString)
                attributedUsername.append(attributedQuestion)
                attributedUsername.append(extraString)
                attributedUsername.append(attributedChosenOption)
                attributedUsername.append(moreString)
                
                
                
                
                
                
                self.notificationLabel = attributedUsername
                self.betKey = betKey
                self.image = #imageLiteral(resourceName: "Single Arrow")
                group.leave()
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
