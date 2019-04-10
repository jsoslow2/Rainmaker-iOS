//
//  SearchViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 25/11/2018.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var betsButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var bets: [Bet]?
    var searchActive = false
    var filtered : [Bet] = []
    
    var tableFilter : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        changeFilters()

        searchBar.delegate = self as UISearchBarDelegate
        
        BetService.getAvailableBets { (allBets) in
            self.bets = allBets.filter({ (bet) -> Bool in
                bet.isActive == 1
            })
            self.filtered = self.bets!
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeFilters()
    }
    
    func changeFilters () {
        if tableFilter == 0 {
            betsButton.backgroundColor = Constants.mintGreen
            betsButton.titleLabel?.textColor = UIColor.white
            usersButton.backgroundColor = Constants.badGrey
            usersButton.titleLabel?.textColor = UIColor.darkText
        } else if tableFilter == 1 {
            betsButton.backgroundColor = Constants.badGrey
            betsButton.titleLabel?.textColor = UIColor.darkText
            usersButton.backgroundColor = Constants.mintGreen
            usersButton.titleLabel?.textColor = UIColor.white
        }
    }
    
    @IBAction func betsButtonPressed(_ sender: Any) {
        tableFilter = 0
        changeFilters()
    }
    
    @IBAction func usersButtonPressed(_ sender: Any) {
        tableFilter = 1
        changeFilters()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {filtered = bets!
            tableView.reloadData(); return}
        
        filtered = (bets?.filter({ (Bet) -> Bool in
            Bet.betQuestion.lowercased().contains(searchText.lowercased())
        }))!
        
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, SearchTableViewCellDelegate {
    func didTapBetButton(which button: Int, on cell: SearchTableViewCell) {
        
        
        guard let bets = bets, let indexPath = self.tableView.indexPath(for: cell)
            else { return }
        
        let bet = bets[indexPath.row]
        
        func chosenOption () -> String {
            if button == 0 {
                return bet.firstBetOption
            } else {
                return bet.secondBetOption
            }
        }
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to bet $5 on " + chosenOption() + " ?", preferredStyle: .alert)
        
        let dialogMessage2 = UIAlertController(title: "Error", message: "You have already placed a bet on this!", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK",  style: .default, handler: { (action) -> Void in
            
            //if ok, you do the bet
            BetService.bet(withBetKey: bet.betKey!, chosenBet: button, withBetAmount: 5) { (bool, postID) in
                if !bool {
                    self.present(dialogMessage2, animated: true, completion: nil)
                } else {
                    
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
        let rainmakerGreen = UIColor(displayP3Red: 0.184, green: 0.788, blue: 0.588, alpha: 1.0)
        ok.setValue(rainmakerGreen, forKey: "titleTextColor")
        dialogMessage.addAction(cancel)
        cancel.setValue(UIColor.gray, forKey: "titleTextColor")
        
        dialogMessage.preferredAction = ok
        dialogMessage2.addAction(ok2)
        
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchViewCell")! as! SearchTableViewCell

        cell.delegate = self
        
        
        let bet = filtered[indexPath.row]
        
        cell.betQuestion.text = bet.betQuestion
        
        cell.firstBetOption.setTitle(bet.firstBetOption, for: .normal)
        cell.secondBetOption.setTitle(bet.secondBetOption, for: .normal)
        cell.typeOfGame.text = bet.typeOfGame
        
        print(bet)
        return cell
    }
    
}
