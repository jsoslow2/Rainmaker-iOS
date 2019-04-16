//
//  OtherUserProfileViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 2/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class OtherUserProfileViewController: UIViewController {
    
    var transferText = ""
    
    let mintGreen = (UIColor(red: 0.494, green: 0.831, blue: 0.682, alpha: 1.0))
    let badGrey = (UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1.0))

    var bets : [ProfileBet]?
    var userID = ""
    var currentUID = Auth.auth().currentUser?.uid
    var imageURL : String?
    var numberOfCorrectBets = 0
    var numberOfIncorrectBets = 0
    var numberOfUnfinishedBets = 0
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var totalBetsLabel: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = transferText
        userID = transferText
        
        followButton.backgroundColor = Constants.badGrey
        followButton.layer.cornerRadius = 10
        followButton.addShadowView()
        
        //allocate delegate and datasource
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        //make profile pic rounded
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        profilePic.clipsToBounds = true
        
        //add divider line at the top of the table view
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        
        //get the username and set the username
        UserService.getUsername(userUID: userID, completion: ({ (theName) in
            self.username.text = theName
        }))
        
        //set the total bets
        UserService.getBets(userUID: userID) { (totalBets) in
            self.totalBetsLabel.text = String(totalBets)
        }
        
        //set the current money
        UserService.getMoney(userUID: userID) { (currentMoney) in
            self.totalMoney.text = String(currentMoney)
        }
        
        //Load the Data
        BetService.getUsersActiveBets(userID: userID) { (allBets) in
            self.bets = allBets
            self.tableView.reloadData()
            self.countWins(allbets: self.bets!)
        }
        
        //Load the Propic
        UserService.getImageURL(userUID: userID) { (imageURL) in
            self.imageURL = imageURL
            
            let url = URL(string: imageURL)
            let session = URLSession.shared
            
            session.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    
                    DispatchQueue.main.async {
                        self.profilePic.image = UIImage(data: data!)
                    }
                }
            }).resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func countWins(allbets: [ProfileBet]) {
        numberOfUnfinishedBets = 0
        numberOfIncorrectBets = 0
        numberOfCorrectBets = 0
        for bet in allbets {
            if bet.isActive == 1 {
                numberOfUnfinishedBets += 1
            } else if bet.rightAnswer == bet.chosenBet {
                numberOfCorrectBets += 1
            } else {
                numberOfIncorrectBets += 1
            }
        }
        lossLabel.text = String(numberOfIncorrectBets)
        winsLabel.text = String(numberOfCorrectBets)
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        UserService.addFollower(currentUID: currentUID!, otherUID: userID) { (bool) in
            if bool {
                let dialogMessage = UIAlertController(title: "Followed", message: "You have just followed \(self.username.text!)", preferredStyle: .alert)
                
                let ok =  UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                })
                
                dialogMessage.addAction(ok)
                
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
    }
    
}


extension OtherUserProfileViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bets = bets?.reversed()
        
        if let bets = bets?.reversed() {
            return bets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherUserProfileBetCell")! as! OtherUserProfileTableViewCell
        
        guard let bets = bets else {return cell}
        
        let bet = bets[indexPath.row]
        
        cell.betQuestion.text = bet.betQuestion
        cell.betAmount.text = String(bet.betAmount)
        
        BetService.getInfoOfBet(betKey: bet.betKey) { (a, b, firstBetOption, secondBetOption, c, d, e, f) in
            if bet.chosenBet == 0 {
                cell.typeOfGame.text = firstBetOption
            } else {
                cell.typeOfGame.text = secondBetOption
            }
        }
        
        cell.rightAnswer = bet.rightAnswer
        cell.chosenOption = bet.chosenBet
        
        cell.awakeFromNib()
        
        return cell
    }
    
    
}

