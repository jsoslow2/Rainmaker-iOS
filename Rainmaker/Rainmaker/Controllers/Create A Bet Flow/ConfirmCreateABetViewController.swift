//
//  ConfirmCreateABetViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/10/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ConfirmCreateABetViewController : UIViewController {
    let mintGreen = (UIColor(red: 0.494, green: 0.831, blue: 0.682, alpha: 1.0))
    let badGrey = (UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1.0))
    
    var uid: String?
    var username : String?
    var betQuestion: String?
    var currentUser : String?
    var currentUsername : String?
    var firstBetOption : String?
    var secondBetOption : String?
    var chosenOption : Int?
    
    
    @IBOutlet weak var betTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var betQuestionLabel: UILabel!
    @IBOutlet weak var firstBetButton: UIButton!
    @IBOutlet weak var secondBetButton: UIButton!
    @IBOutlet weak var firstBetText: UITextField!
    @IBOutlet weak var secondBetText: UITextField!
    @IBOutlet weak var confirmBetButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmBetButton.layer.cornerRadius = 10
        
        //Bet title code
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedUsername = NSMutableAttributedString(string:currentUsername!, attributes: attrs)
        let attributedOtherUsername = NSMutableAttributedString(string: username!, attributes: attrs)
        let normalText = " bet with "
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedUsername.append(normalString)
        attributedUsername.append(attributedOtherUsername)
        
        betTitle.attributedText = attributedUsername
        /// End
        
        betQuestionLabel.text = betQuestion
        
        //First Bet Option
        if (firstBetText.text?.isEmpty)! {
            firstBetOption = "Yes"
        } else {
            firstBetOption = firstBetText.text
        }
        
        //Second Bet Option
        if (secondBetText.text?.isEmpty)! {
            secondBetOption = "No"
        } else {
            secondBetOption = secondBetText.text
        }
        

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pickFirstButton(_ sender: Any) {
        chosenOption = 0
        firstBetButton.backgroundColor = mintGreen
        secondBetButton.backgroundColor = badGrey
    }
    
    
    @IBAction func pickSecondButton(_ sender: Any) {
        chosenOption = 1
        firstBetButton.backgroundColor = badGrey
        secondBetButton.backgroundColor = mintGreen
    }
    
    
    
    @IBAction func confirmBet(_ sender: Any) {
        //Implement create a bet function
    }
}
