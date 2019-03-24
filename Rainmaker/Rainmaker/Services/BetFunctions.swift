//
//  BetFunctions.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/23/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseAuth

struct BetFunctions {
    static func countWins(allbets: [ProfileBet]) {
        for bet in allbets {
            if bet.rightAnswer == bet.chosenBet {
                numberOfCorrectBets += 1
            }
        }
    }
    
    static func changeMoney(allBets: [ProfileBet]) {
        countWins(allbets: allBets)
        let wonMoney = numberOfCorrectBets * 5
        let allMoney = User.currentMoney + wonMoney
        User.currentMoney = allMoney
        totalMoney.text = "$" + String(allMoney)
        BetService.changeBetMoney(withAmount: allMoney) { (bool) in
            print(bool)
        }
    }
}
