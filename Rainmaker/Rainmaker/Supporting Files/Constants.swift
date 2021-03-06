//
//  Constants.swift
//  Rainmaker
//
//  Created by Jack Soslow on 11/27/18.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

struct Constants {
    
    struct Segue {
        static let toCreateUsername = "toCreateUsername"
    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
    }
    
    static let mintGreen = (UIColor(red: 0.494, green: 0.831, blue: 0.682, alpha: 1.0))
    static let badGrey = (UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1.0))
    
    
    static var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Constants.mintGreen
        
        return refreshControl
    }()
    
    
    static func reloadTable (table: UITableView) {
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            table.reloadData()
            Constants.refresher.endRefreshing()
        }
    }
    
    static let currentUID = Auth.auth().currentUser!.uid
}
