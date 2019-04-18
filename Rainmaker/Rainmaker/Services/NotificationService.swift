//
//  NotificationService.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/18/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct NotificationService {
    static func createBetNotification(currentUsername: String, otherUID: String, betKey: String, chosenOption: Int, timeStamp: String, completion: @escaping(Bool) -> Void) {
        
        let ref = Database.database().reference().child("Notifications").child(otherUID)
        
        var updatedData = [String: Any]()
        
        updatedData["isBet"] = 1
        updatedData["betKey"] = betKey
        updatedData["isFollow"] = 0
        updatedData["otherChosenBet"] = chosenOption
        updatedData["otherUsername"] = currentUsername
        
        ref.child(timeStamp).updateChildValues(updatedData)
        completion(true)
    }
    
    
    static func loadNotifications(currentUID: String, completion: @escaping([Notification]) -> Void) {
        let group = DispatchGroup()
        let ref = Database.database().reference().child("Notifications").child(currentUID)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {completion([]); return}
            
            var notifications = [Notification]()
            
            for snap in snapshot {
                let notification = Notification(snapshot: snap, group: group)
                notifications.append(notification!)
            }
            group.notify(queue: .main, execute: {
                completion(notifications)
            })
            
        }
    }
}
