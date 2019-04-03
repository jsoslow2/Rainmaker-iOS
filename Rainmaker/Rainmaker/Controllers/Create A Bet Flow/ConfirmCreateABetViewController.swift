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
    var typeOfGame: String?
    
    
    @IBOutlet weak var betTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var betQuestionLabel: UILabel!
    @IBOutlet weak var firstBetButton: UIButton!
    @IBOutlet weak var secondBetButton: UIButton!
    @IBOutlet weak var firstBetText: UITextField!
    @IBOutlet weak var secondBetText: UITextField!
    @IBOutlet weak var confirmBetButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        confirmBetButton.layer.cornerRadius = 10
        firstBetButton.layer.cornerRadius = 10
        secondBetButton.layer.cornerRadius = 10
        confirmBetButton.addShadowView()
        firstBetButton.addShadowView()
        secondBetButton.addShadowView()
        
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
    
    func checkSubtitle () {
        if (subtitleTextField.text?.isEmpty)! {
            typeOfGame = "Custom Bet"
        } else {
            typeOfGame = subtitleTextField.text!
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
        checkSubtitle()
        // 1. Give Error if you haven't picked a bet option
        if currentUsername == "jsoslow2" && chosenOption == nil {
            BetService.createBet(userID: currentUser!, betQuestion: betQuestion!, firstBetOption: firstBetOption!, secondBetOption: secondBetOption!, otherUsername: username!, typeOfGame: typeOfGame!, createBet: 0) { (uniqueID) in
                self.betID = uniqueID
            }
        } else if chosenOption == nil {
            let dialogMessage2 = UIAlertController(title: "Error", message: "Choose one of the bet options to make the bet", preferredStyle: .alert)
            let ok2 = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            dialogMessage2.addAction(ok2)
            self.present(dialogMessage2, animated: true, completion: nil)
        } else {
            // 2. Create a new bet in Bets tab
            BetService.createBet(userID: currentUser!, betQuestion: betQuestion!, firstBetOption: firstBetOption!, secondBetOption: secondBetOption!, otherUsername: username!, typeOfGame: typeOfGame!, createBet: 1) { (uniqueID) in
                print("yeet")
                self.betID = uniqueID
                
            }
            
            //3. Update users bets
            BetService.bet(withBetKey: betID!, chosenBet: chosenOption!, withBetAmount: 5) { (Boolean, postID) in
                if !Boolean {
                    print("no worky")
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HomeViewController
        
        checkBetTexts()
        checkSubtitle()
        
        if username == "" || chosenOption == nil {
            print("newbet created")
        } else {
            let newPost = HomePost(chosenBet: chosenOption!, betKey: betID!, image: #imageLiteral(resourceName: "default copy"), betQuestion: betQuestion!, typeOfGame: typeOfGame!, UID: currentUser!, username: currentUsername!, firstOption: firstBetOption!, secondOption: secondBetOption!)
            newPost.isActive = 1
            newPost.rightAnswer = -1
            newPost.otherUsername = username!
            newPost.createBet = 1
            
            destinationVC.createdBet = newPost
            destinationVC.didComeFromConfirm = 1
        }
    }
    
}
