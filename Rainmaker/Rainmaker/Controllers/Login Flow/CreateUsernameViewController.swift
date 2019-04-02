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
    
    let mintGreen = (UIColor(red: 0.494, green: 0.831, blue: 0.682, alpha: 1.0))

    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        continueButton.layer.cornerRadius = 20
        super.viewDidLoad()
        
        username.tintColor = mintGreen
        username.tintColorDidChange()
        
        username.attributedPlaceholder = NSAttributedString(string: "Choose Username",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}

    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let usernameText = username.text,
            !usernameText.isEmpty else { return }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! betForFreeViewController
        destinationVC.username = username.text
    }
    
}
