//
//  betForFreeViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class betForFreeViewController : UIViewController {
    
    var username : String?
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    let combination = NSMutableAttributedString()
    var yourAttributes : Any?
    var yourOtherAttributes : Any?
    
    let mintGreen = (UIColor(red: 0.494, green: 0.831, blue: 0.682, alpha: 1.0))
    let badGrey = (UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 20
        
        
        yourAttributes = [NSAttributedString.Key.foregroundColor: mintGreen, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 45)]
        yourOtherAttributes = [NSAttributedString.Key.foregroundColor: mintGreen, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14)]
        let partOne = NSMutableAttributedString(string: String(100), attributes: yourAttributes as? [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: "drops", attributes: yourOtherAttributes as? [NSAttributedString.Key : Any])
        
        
        combination.append(partOne)
        combination.append(partTwo)
        
        moneyLabel.attributedText = combination
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
