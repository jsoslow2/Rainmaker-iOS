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
    
    var bets = User.activeBets
    let userID = Auth.auth().currentUser!.uid
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        BetService.getCurrentMoney { (money) in
            if let money = money {
                User.currentMoney = money
            }
        }
        
        BetService.getUsersActiveBets(userID: userID) { (allBets) in
                self.bets = allBets
                self.tableView.reloadData()
                print(allBets)
                print(self.userID)
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bets = bets {
            print(bets.count)
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
        cell.betAmount.text = String(bet.betAmount)
        cell.typeOfGame.text = bet.typeOfGame

        print(bet.betQuestion)
        print(bet.typeOfGame)
        return cell
    }
    
}

