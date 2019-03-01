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

    var bets : [ProfileBet]?
    var userID = ""
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var totalBetsLabel: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = transferText
        userID = transferText
        
        //allocate delegate and datasource
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
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
        
        //set the total bets and current money labels
        ///TODO
        
        
        //Load the Data
        BetService.getUsersActiveBets(userID: userID) { (allBets) in
            self.bets = allBets
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.betAmount.text = "$" + String(bet.betAmount)
        cell.typeOfGame.text = bet.typeOfGame
        
        if bet.rightAnswer == bet.chosenBet {
            cell.winLoss.text = "W"
        } else if bet.isActive == 1 {
            cell.winLoss.text = "NA"
            cell.winLoss.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        } else {
            cell.winLoss.text = "L"
            cell.winLoss.textColor = #colorLiteral(red: 0.9882352941, green: 0.3607843137, blue: 0.231372549, alpha: 1)
        }
        
        return cell
    }
    
    
}

