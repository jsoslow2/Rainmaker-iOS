//
//  UserService.swift
//  Rainmaker
//
//  Created by Jack Soslow on 11/26/18.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func create(_ firUser: FIRUser, usernameText: String, completion: @escaping (User?) -> Void) {
        var userAttrs = [String : Any]()
            
        userAttrs["username"] = usernameText
        userAttrs["currentMoney"] = 100
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
        
    }
    
    static func getNumberOfBets(userUID: String, completion: @escaping(Int) -> Void) {
        let ref = Database.database().reference().child("users").child(userUID)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let numberOfBets = dict["numberOfBets"] as? Int
                else {completion(-1); return}
            
            completion(numberOfBets)
            
        }
        
        
    }
    
    static func getUsername(userUID: String, completion: @escaping(String) -> Void) {
        let ref = Database.database().reference().child("users").child(userUID)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let username = dict["username"] as? String
                else {completion(""); return}
            
            completion(username)
            
        }
    }
    
    static func getBets(userUID: String, completion: @escaping(Int) -> Void) {
        let ref = Database.database().reference().child("users").child(userUID)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
            let numberOfBets = dict["numberOfBets"] as? Int
                else {completion(0); return}
            
            completion(numberOfBets) 
        }
    }
    
    static func getMoney(userUID: String, completion: @escaping(Int) -> Void) {
        let ref = Database.database().reference().child("users").child(userUID)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let currentMoney = dict["currentMoney"] as? Int
                else {completion(0); return}
            
            completion(currentMoney)
        }
    }
    
    static func getImageURL(userUID: String, completion: @escaping(String) -> Void) {
        let ref = Database.database().reference().child("users").child(userUID)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any],
                let imageURL = dict["imageURL"] as? String
                else {completion(""); return}
            
            completion(imageURL)
        }
    }
    
    static func adjustProfilePic(userUID: String, imageURL: String, completion: @escaping(Bool) -> Void) {
        let ref = Database.database().reference().child("users").child(userUID)
        
        var newProfilePic = [String : String] ()
        newProfilePic["imageURL"] = imageURL
        
        ref.updateChildValues(newProfilePic)
        completion(true)
    }
    
    
    
    static func getAllUsers(completion: @escaping([String]) -> Void) {
        let ref = Database.database().reference().child("users")
        
        var allUsernames : [String] = []
        
            ref.observeSingleEvent(of: .value) { (snapshot) in
                
                for snap in snapshot.children.allObjects {
                    let i = snap as? DataSnapshot
                    let dict = i?.value as? [String: Any]
                    let username = dict?["username"] as? String
                    allUsernames.append(username!)
                }
                completion(allUsernames)
            }
        }
    
    
    static func getAllUsersData(completion: @escaping([UsableUser]) -> Void) {
        let ref = Database.database().reference().child("users")
        
        var allUsers : [UsableUser] = []
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            for snap in snapshot.children.allObjects {
                let i = snap as? DataSnapshot
                let user = UsableUser(uid: i!.key, snapshot: i!)
                allUsers.append(user!)
            }
            completion(allUsers)
        }
    }
}



