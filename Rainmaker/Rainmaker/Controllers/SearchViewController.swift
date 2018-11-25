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
        
        BetService.bet(withBetKey: bet.betKey!, chosenBet: button) { (bool) in
            if !bool {
                print("FAILED in updating bet feed in searchviewcontroller")
            }
        }
            
        
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
