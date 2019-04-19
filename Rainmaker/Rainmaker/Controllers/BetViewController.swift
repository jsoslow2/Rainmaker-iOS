//
//  BetViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/18/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BetViewController : UIViewController {
    
    @IBOutlet weak var typeOfGame: UILabel!
    @IBOutlet weak var betQuestion: UILabel!
    @IBOutlet weak var firstBetOption: UIButton!
    @IBOutlet weak var secondBetOption: UIButton!
    
    var transferText : String?
    var betKey : String?
    var isActive : Int?
    var firstBetText : String?
    var secondBetText : String?
    
    
    let dialogMessage2 = UIAlertController(title: "Error", message: "You have already placed a bet on this!", preferredStyle: .alert)
    
    let dialogMessage3 = UIAlertController(title: "Bet No Longer Active", message: "The result of this bet has already finished so you cannot place a bet on it", preferredStyle: .alert)
    
    let ok2 = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        
    })
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstBetOption.layer.cornerRadius = 20
        firstBetOption.backgroundColor = Constants.badGrey
        firstBetOption.addShadowView()
        
        secondBetOption.layer.cornerRadius = 20
        secondBetOption.backgroundColor = Constants.badGrey
        secondBetOption.addShadowView()
        
        betKey = transferText
        
        
        BetService.getInfoOfBet(betKey: betKey!) { (betQuestion, typeOfGame, firstBetOption, secondBetOption, isActive, rightAnswer, otherUsername, createBet) in
            self.betQuestion.text = betQuestion
            self.typeOfGame.text = typeOfGame
            self.firstBetOption.setTitle(firstBetOption, for: .normal)
            self.secondBetOption.setTitle(secondBetOption, for: .normal)
            
            self.isActive = isActive
            self.firstBetText = firstBetOption
            self.secondBetText = secondBetOption
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func firstBetPressed(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to bet 5 drops on " + self.firstBetText! + " ?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            BetService.bet(withBetKey: self.betKey!, chosenBet: 0, withBetAmount: 5) { (bool, postID) in
                if !bool {
                    self.dialogMessage2.addAction(self.ok2)
                    self.present(self.dialogMessage2, animated: true, completion: nil)
                }
            }
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        if isActive == 1 {
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            dialogMessage3.addAction(ok2)
            self.present(dialogMessage3, animated: true, completion: nil)
        }
    }
    
    @IBAction func secondBetPressed(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to bet 5 drops on " + self.secondBetText! + " ?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            BetService.bet(withBetKey: self.betKey!, chosenBet: 1, withBetAmount: 5) { (bool, postID) in
                if !bool {
                    self.dialogMessage2.addAction(self.ok2)
                    self.present(self.dialogMessage2, animated: true, completion: nil)
                }
            }
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        if isActive == 1 {
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            dialogMessage3.addAction(ok2)
            self.present(dialogMessage3, animated: true, completion: nil)
        }
    }
    
}
