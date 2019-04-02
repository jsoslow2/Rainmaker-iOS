//
//  CompleteCreateABetViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/7/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class CompleteCreateABetViewController : UIViewController, UITextViewDelegate {
    
    var uid : String?
    var username: String?
    var currentUser = Auth.auth().currentUser!.uid
    var currentUsername : String?
    
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var betQuestionField: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        UserService.getUsername(userUID: currentUser) { (theName) in
            self.currentUsername = theName
        }
        
        
        betQuestionField.delegate = self
        
        betQuestionField.layer.cornerRadius = 10

        continueButton.layer.cornerRadius = 10
        
        testLabel.text = "Creating bet with " + username!
        
        betQuestionField.text = "Type the bet here"
        betQuestionField.textColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ConfirmCreateABetViewController
        
        destinationVC.betQuestion = betQuestionField.text
        destinationVC.uid = uid
        destinationVC.username = username
        destinationVC.currentUsername = currentUsername
        destinationVC.currentUser = currentUser
    }
    
    @IBAction func adminContinue(_ sender: Any) {
        if currentUsername == "jsoslow2" {
            performSegue(withIdentifier: "toConfirmCreateABet", sender: self)
        }
    }
    
    
    @IBAction func continueToFinalStep(_ sender: Any) {
        if betQuestionField.text.isEmpty || betQuestionField.text == "Type the bet here" {
            //send alert that you need to make a bet
            let dialogMessage2 = UIAlertController(title: "Error", message: "You need to make a bet!", preferredStyle: .alert)
            let ok2 = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            dialogMessage2.addAction(ok2)
            self.present(dialogMessage2, animated: true, completion: nil)
            print("test")
        }
        ///
        else {
            print("test2")
            self.performSegue(withIdentifier: "toConfirmCreateABet", sender: self)

        }
    }
    
}
