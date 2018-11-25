//
//  BetService.swift
//  Rainmaker
//
//  Created by Eugene Enclona on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct BetService {
    
    static func getAvailableBets(completion: @escaping ([Bet]) -> Void) {
        
        let ref = Database.database().reference().root.child("Bets")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {
                    return completion([])
            }
            
            let bets: [Bet] = snapshot.reversed().compactMap {
                guard let bet = Bet(snapshot: $0)
                    else {return nil}
                
                return bet
            }
            
            completion(bets)
        }
        
    }
    
    static func bet(withBetKey: String, chosenBet: Int, completion: @escaping (Bool) -> Void) {
        
        //decrease your bet dollars
        //post this bet on your profile feed
        //post this bet on your friends feed
        
        //for now, post this on your home feed!!!
        //let userID = Auth.auth().currentUser!.uid
        let userID = "fakeUSERID"
        let ref = Database.database().reference().child("HomeFeed").child(userID).child(withBetKey)
        
        var updatedData = [String: Any]()
        
        updatedData["chosenBet"] = chosenBet
        updatedData["friendKey"] = userID
        
        ref.updateChildValues(updatedData)
        
    }
    
    
}
