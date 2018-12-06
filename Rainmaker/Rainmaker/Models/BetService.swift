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
    
    //will be displayed in search tab
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
    
    
    
    static func bet(withBetKey: String, chosenBet: Int, withBetAmount: Int, completion: @escaping (Bool) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        
        //post this bet on your profile feed
        let ref = Database.database().reference().child("Profile").child(userID).child("currentBets")
      
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(withBetKey) {
                //bet is already made
                completion(false)
                return
            } else {
                //increase your bet count
                
                let betCountRef = Database.database().reference().child("users").child(User.current.uid)
                
                User.numberOfBets = User.numberOfBets + 1
                
                var newNumberOfBets = [String : Int]()
                newNumberOfBets["numberOfBets"] = User.numberOfBets
                
                betCountRef.updateChildValues(newNumberOfBets)
                
                //decrease your bet dollars
                User.currentMoney = User.currentMoney - withBetAmount
                
                BetService.changeBetMoney(withAmount: User.currentMoney) { (bool) in
                    if !bool {
                        print("failed in changing bet money")
                    }
                }
                
                var updatedData = [String: Any]()
                
                updatedData["chosenBet"] = chosenBet
                updatedData["uidOfBettor"] = userID
                updatedData["betAmount"] = withBetAmount
                
                ref.child(withBetKey).updateChildValues(updatedData)
                
                //post this bet on public feed
                let ref2 = Database.database().reference().child("PublicHomeFeed")
                ref2.observeSingleEvent(of: .value) { (snapshot) in
                    
                    var updatedData = [String: Any]()
                    
                    updatedData["chosenBet"] = chosenBet
                    updatedData["uidOfBettor"] = userID
                    updatedData["betAmount"] = withBetAmount
                    
                    ref2.child(withBetKey).updateChildValues(updatedData)
                    completion(true)
                    
                }
            }
        }
        
        
    }
    
    static func changeBetMoney(withAmount: Int, completion: @escaping(Bool) -> Void) {
        
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(userID)
        
        var updatedData = [String: Any]()
        
        updatedData["currentMoney"] = withAmount
        
        ref.updateChildValues(updatedData)
        
        
    }
    
    static func getCurrentMoney(completion: @escaping(Int?) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(userID)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let currentMoney = dict["currentMoney"] as? Int
                else { completion(nil); return }
            
            completion(currentMoney)
            
        }
    }
    
    static func getUsersActiveBets(userID: String, completion: @escaping([ProfileBet]) -> Void) {
        let group = DispatchGroup()
        let profileRef = Database.database().reference().child("Profile").child(userID).child("currentBets")
        profileRef.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {completion([]); return}
            print(snapshot)
            

            
            var bets = [ProfileBet]()
            for snap in snapshot {
                let bet = ProfileBet(snapshot: snap)
                group.enter()
                BetService.getInfoOfBet(betKey: bet!.betKey, completion: { (betQuestion, typeOfGame) in
                    bet?.betQuestion = betQuestion
                    bet?.typeOfGame = typeOfGame
                    group.leave()
                })
                bets.append(bet!)
            }
            
            group.notify(queue: .main, execute: {
                completion(bets)
            })
            
            
            
        }
    }
    
    static func getInfoOfBet(betKey: String, completion: @escaping(String, String) -> Void) {
        
        let ref = Database.database().reference().child("Bets").child(betKey)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let betQuestion = dict["betQuestion"] as? String,
                let typeOfGame = dict["typeOfGame"] as? String
                else {completion("", ""); return}
            
            completion(betQuestion, typeOfGame)
        }
    }
    
    
    static func getBetQuestion(betKey: String, completion: @escaping(String?) -> Void) {
        let ref = Database.database().reference().child("Bets").child(betKey)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let betQuestion = dict["betQuestion"] as? String
                else { completion(nil); return }
            
            completion(betQuestion)
            
        }
    }
    
    
}
