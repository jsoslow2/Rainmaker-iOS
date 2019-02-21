//
//  ProfileViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 12/5/18.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    
    
    
    var bets : [ProfileBet]?
    let userID = Auth.auth().currentUser!.uid
    var username: String?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var totalBetsLabel: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //allocate delegate and datasource
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        //make propic circular
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        profilePic.clipsToBounds = true
        
        //add divider line at the top of the table view
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        
       
        //get current money
        BetService.getCurrentMoney { (money) in
            if let money = money {
                User.currentMoney = money
            }
        }
        
        //get the username and set the username
        UserService.getUsername(userUID: userID) { (theName) in
            self.username = theName

            self.name.text = self.username
        }
        
        //set the total bets and current money labels
        totalBetsLabel.text = String(User.numberOfBets)
        totalMoney.text = "$" + String(User.currentMoney)
        
        //LOAD THE DATA
        BetService.getUsersActiveBets(userID: userID) { (allBets) in
                self.bets = allBets
                self.tableView.reloadData()
            }
        
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

extension ProfileViewController: UITableViewDataSource {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //cool table animation
        animateTable()
        
        print("test")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bets = bets?.reversed()
        
        if let bets = bets?.reversed() {
            return bets.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileBetCell")! as! ProfileBetTableViewCell
        
        guard let bets = bets else {return cell}
        
        let bet = bets[indexPath.row]
        
        cell.betQuestion.text = bet.betQuestion
        cell.betAmount.text = "$" + String(bet.betAmount)
        cell.typeOfGame.text = bet.typeOfGame

        return cell
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
}

