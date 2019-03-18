//
//  BetService.swift
//  Rainmaker
//
//  Created by Jack Soslow on 25/11/2018.
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
                
                dump(bet)
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
                
                let timestamp = Date().millisecondsSince1970
                let timestampString = String(timestamp)
                
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
                let ref2 = Database.database().reference().child("HomeFeed")
                ref2.observeSingleEvent(of: .value) { (snapshot) in
                    

                    
                    var updatedData = [String: Any]()
                    
                    updatedData["chosenBet"] = chosenBet
                    updatedData["uidOfBettor"] = userID
                    updatedData["betAmount"] = withBetAmount
                    updatedData["betKey"] = withBetKey
                    
                    let UIDBetCombo = String(timestampString) + String(userID)
                    
                    ref2.child(UIDBetCombo).updateChildValues(updatedData)
                    completion(true)
                    
                }
            }
        }
        
        
    }
    
    static func createBet(betQuestion: String, firstBetOption: String, secondBetOption: String, otherUsername: String, subtitle: String, createBet: Int, completion: @escaping(String) -> Void) {
        
        let timestamp = Date().millisecondsSince1970
        let timestampString = String(timestamp)

        
        let ref = Database.database().reference().child("Bets")
        
        var updatedData = [String: Any]()
        
        updatedData["betQuestion"] = betQuestion
        updatedData["firstBetOption"] = firstBetOption
        updatedData["isActive"] = 1
        updatedData["rightAnswer"] = -1
        updatedData["secondBetOption"] = secondBetOption
        updatedData["typeOfGame"] = subtitle
        updatedData["createBet"] = createBet
        updatedData["otherUsername"] = otherUsername
        
        ref.child(timestampString).updateChildValues(updatedData)
        completion(timestampString)
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
            

            
            var bets = [ProfileBet]()
            for snap in snapshot {
                let bet = ProfileBet(snapshot: snap)
                group.enter()
                BetService.getInfoOfBet(betKey: bet!.betKey, completion: { (betQuestion, typeOfGame, firstBetOption, secondBetOption, isActive, rightAnswer, otherUsername, createBet) in
                    bet?.betQuestion = betQuestion
                    bet?.typeOfGame = typeOfGame
                    bet?.isActive = isActive
                    bet?.rightAnswer = rightAnswer
                    group.leave()
                })
                bets.append(bet!)
            }
            
            group.notify(queue: .main, execute: {
                completion(bets)
            })
            
        }
    }
    
    
    static func getInfoOfBet(betKey: String, completion: @escaping(String, String, String, String, Int, Int, String, Int) -> Void) {
        
        let ref = Database.database().reference().child("Bets").child(betKey)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let betQuestion = dict["betQuestion"] as? String,
                let typeOfGame = dict["typeOfGame"] as? String,
                let firstBetOption = dict["firstBetOption"] as? String,
                let secondBetOption = dict["secondBetOption"] as? String,
                let isActive = dict["isActive"] as? Int,
                let rightAnswer = dict["rightAnswer"] as? Int,
                let otherUsername = dict["otherUsername"] as? String,
                let createBet = dict["createBet"] as? Int
                else {completion("", "", "", "", 0, 0, "", 0); return}
            
            completion(betQuestion, typeOfGame, firstBetOption, secondBetOption, isActive, rightAnswer, otherUsername, createBet)
        }
    }
    
    static func getHomeFeedBets(completion: @escaping([HomePost]) -> Void) {
        let group = DispatchGroup()
        let profileRef = Database.database().reference().child("HomeFeed")
        profileRef.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {completion([]); return}
            print(snapshot)
            
            
            
            var bets = [HomePost]()
            for snap in snapshot {
                print(snap)
                let bet = HomePost(snapshot: snap)
                group.enter()
                BetService.getInfoOfBet(betKey: bet!.betKey, completion: { (betQuestion, typeOfGame, firstBetOption, secondBetOption, isActive, rightAnswer, otherUsername, createBet) in
                    bet?.betQuestion = betQuestion
                    bet?.typeOfGame = typeOfGame
                    bet?.firstOption = firstBetOption
                    bet?.secondOption = secondBetOption
                    bet?.isActive = isActive
                    bet?.rightAnswer = rightAnswer
                    bet?.otherUsername = otherUsername
                    bet?.createBet = createBet
                    
                    UserService.getUsername(userUID: bet!.UID , completion: { (username) in
                            bet?.username = username
                        group.leave()
                    })
                })
                bets.append(bet!)
            }
            
            group.notify(queue: .main, execute: {
                completion(bets)
            })
            
        }
    }
    
    
    
}


extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
