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
    var otherOption : Int?
    var betID : String?
    
    
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
        firstBetButton.layer.cornerRadius = 10
        secondBetButton.layer.cornerRadius = 10
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkBetTexts () {
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
    
    @IBAction func pickFirstButton(_ sender: Any) {
        chosenOption = 0
        otherOption = 1
        firstBetButton.backgroundColor = mintGreen
        secondBetButton.backgroundColor = badGrey
    }
    
    
    @IBAction func pickSecondButton(_ sender: Any) {
        chosenOption = 1
        otherOption = 0
        firstBetButton.backgroundColor = badGrey
        secondBetButton.backgroundColor = mintGreen
    }
    

    
    @IBAction func confirmBet(_ sender: Any) {
        checkBetTexts()
        // 1. Give Error if you haven't picked a bet option
        if chosenOption == nil {
            let dialogMessage2 = UIAlertController(title: "Error", message: "Choose one of the bet options to make the bet", preferredStyle: .alert)
            let ok2 = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            dialogMessage2.addAction(ok2)
            self.present(dialogMessage2, animated: true, completion: nil)
        } else {
            // 2. Create a new bet in Bets tab
            BetService.createBet(betQuestion: betQuestion!, firstBetOption: firstBetOption!, secondBetOption: secondBetOption!, otherUsername: username!) { (uniqueID) in
                print("yeet")
                self.betID = uniqueID
                
            }
            
            //3. Update users bets
            BetService.bet(withBetKey: betID!, chosenBet: chosenOption!, withBetAmount: 0) { (Boolean) in
                if !Boolean {
                    print("no worky")
                }
                
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HomeViewController
    }
    
}
