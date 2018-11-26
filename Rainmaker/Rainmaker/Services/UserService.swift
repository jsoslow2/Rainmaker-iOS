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
    static func create(_ firUser: FIRUser, usernameText: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": usernameText]
        
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
}
