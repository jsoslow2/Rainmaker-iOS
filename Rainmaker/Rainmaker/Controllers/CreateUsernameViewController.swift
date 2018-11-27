//
//  CreateUsernameViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 11/26/18.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase


class CreateUsernameViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        continueButton.layer.cornerRadius = 20
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}

    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let usernameText = username.text,
            !usernameText.isEmpty else { return }
        
        
        UserService.create(firUser, usernameText: usernameText) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window!.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            
        
            
            print("Created new user: \(user.username)")
        
        }
        
        
        
    }
    
    
    
    
}
