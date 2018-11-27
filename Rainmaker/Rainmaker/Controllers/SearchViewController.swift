//
//  SearchViewController.swift
//  Rainmaker
//
//  Created by Eugene Enclona on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bets: [Bet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BetService.getAvailableBets { (bets) in
            self.bets = bets
            self.tableView.reloadData()
        }
    }
    

}

extension SearchViewController: UITableViewDataSource, SearchTableViewCellDelegate {
    func didTapBetButton(which button: Int, on cell: SearchTableViewCell) {
        
        guard let bets = bets, let indexPath = self.tableView.indexPath(for: cell)
            else { return }
        
        let bet = bets[indexPath.row]
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to place this bet?", preferredStyle: .alert)
        
        let dialogMessage2 = UIAlertController(title: "Error", message: "You have already placed a bet on this!", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            //if ok, you do the bet
            BetService.bet(withBetKey: bet.betKey!, chosenBet: button) { (bool) in
                if !bool {
                    self.present(dialogMessage2, animated: true, completion: nil)
                } else {
                    print("bet successful!")
                }
            }
            
        })
        
        let ok2 = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        dialogMessage2.addAction(ok2)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
        
        
        
        
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let bets = bets {
            return bets.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchViewCell")! as! SearchTableViewCell

        cell.delegate = self
        
        guard let bets = bets else { return cell}
        
        let bet = bets[indexPath.row]
        
        cell.betQuestion.text = bet.betQuestion
        
        cell.firstBetOption.setTitle(bet.firstBetOption, for: .normal)
        cell.secondBetOption.setTitle(bet.secondBetOption, for: .normal)
        cell.typeOfGame.text = bet.typeOfGame
        
        return cell
    }
    
}
