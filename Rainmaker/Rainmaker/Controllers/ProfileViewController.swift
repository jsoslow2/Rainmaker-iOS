//
//  ProfileViewController.swift
//  Rainmaker
//
//  Created by Eugene Enclona on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //access profileBets data through User.activeBets
    //access numberofbets using User.numberOfBets
    
    var profileData: [ProfileBet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load bets to data
        self.profileData = User.activeBets
        
    }
    

    

}
