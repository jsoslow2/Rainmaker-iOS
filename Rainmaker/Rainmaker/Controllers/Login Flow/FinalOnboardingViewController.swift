//
//  FinalOnboardingViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/30/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class FinalOnboardingViewController : UIViewController {
    
    @IBOutlet weak var continueToHome: UIButton!
    
    var username : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueToHome.layer.cornerRadius = 20
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let usernameText = username
        let firUser = Auth.auth().currentUser
        
        UserService.create(firUser!, usernameText: usernameText!) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window!.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
            
            
            print("Created new user: \(user.username)")
        }
    }
    
}
