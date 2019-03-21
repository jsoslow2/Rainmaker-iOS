//
//  ConfirmBet.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/20/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class ConfirmBet {
    var betQuestion : String?
    var firstBetOption: String?
    var secondBetOption: String?
    var betKey : String?
    
    init(betQuestion: String, firstBetOption: String, secondBetOption: String) {
        self.betQuestion = betQuestion
        self.firstBetOption = firstBetOption
        self.secondBetOption = secondBetOption
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
        let betQuestion = dict["betQuestion"] as? String,
        let firstBetOption = dict["firstOption"] as? String,
        let secondBetOption = dict["secondOption"] as? String
            else {return nil}
        
        self.betQuestion = betQuestion
        self.firstBetOption = firstBetOption
        self.secondBetOption = secondBetOption
    }
}
