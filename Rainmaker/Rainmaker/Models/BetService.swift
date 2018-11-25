//
//  BetService.swift
//  Rainmaker
//
//  Created by Eugene Enclona on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseDatabase

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
    
    
}
