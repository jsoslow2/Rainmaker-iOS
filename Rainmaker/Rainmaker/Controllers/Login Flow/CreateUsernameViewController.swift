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
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    
    let mintGreen = (UIColor(red: 0.494, green: 0.831, blue: 0.682, alpha: 1.0))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifImage.loadGif(name: "rain white background")
        
        self.hideKeyboardWhenTappedAround()
        continueButton.layer.cornerRadius = 20
        continueButton.addShadowView()

        
        username.tintColor = mintGreen
        username.tintColorDidChange()
        
        username.attributedPlaceholder = NSAttributedString(string: "Choose Username",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14) as Any])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}

    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let _ = Auth.auth().currentUser,
            let usernameText = username.text,
            !usernameText.isEmpty else { return }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! betForFreeViewController
        destinationVC.username = username.text
    }
    
}
