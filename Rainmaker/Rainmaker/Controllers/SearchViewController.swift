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
    
    var searchActive = false
    var bets: [Bet]?
    var allUsers : [UsableUser]?
    var filtered : [Bet] = []
    var filteredUsers : [UsableUser] = []
    
    var passingUID : String?
    
    
    var tableFilter : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        changeFilters()
        
        Constants.refresher.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        tableView.refreshControl = Constants.refresher

        searchBar.delegate = self as UISearchBarDelegate
        
        BetService.getAvailableBets { (allBets) in
            self.bets = allBets.filter({ (bet) -> Bool in
                bet.isActive == 1
            })
            self.filtered = self.bets!
            self.tableView.reloadData()
        }
        
        
        UserService.getAllUsersData { (allUsers) in
            self.allUsers = allUsers
            self.filteredUsers = allUsers
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeFilters()
    }
    
    @objc func reloadTable() {
        print("refreshing data")
        
        Constants.reloadTable(table: tableView)
    }
    
    func changeFilters () {
        if tableFilter == 0 {
            betsButton.backgroundColor = Constants.mintGreen
            usersButton.backgroundColor = Constants.badGrey
            usersButton.titleLabel?.textColor = UIColor.darkText
        } else if tableFilter == 1 {
            betsButton.backgroundColor = Constants.badGrey
            betsButton.titleLabel?.textColor = UIColor.darkText
            usersButton.backgroundColor = Constants.mintGreen
        }
    }
    
    @IBAction func betsButtonPressed(_ sender: Any) {
        tableFilter = 0
        changeFilters()
        tableView.reloadData()
        tableView.rowHeight = 141
    }
    
    @IBAction func usersButtonPressed(_ sender: Any) {
        tableFilter = 1
        changeFilters()
        tableView.reloadData()
        tableView.rowHeight = 65
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if tableFilter == 0 {
            guard !searchText.isEmpty else {filtered = bets!
                tableView.reloadData(); return}
            
            filtered = (bets?.filter({ (Bet) -> Bool in
                Bet.betQuestion.lowercased().contains(searchText.lowercased())
            }))!
            
            tableView.reloadData()
        } else {
            guard !searchText.isEmpty else {filteredUsers = allUsers!
                tableView.reloadData(); return}
            
            filteredUsers = (allUsers!.filter({ (User) -> Bool in
                User.username.lowercased().contains(searchText.lowercased())
            }))
            tableView.reloadData()
        }
        
    }
}

extension SearchViewController: UITableViewDataSource, SearchTableViewCellDelegate, UserSearchTableViewCellDelegate {
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
        if tableFilter == 0 {
            return filtered.count
        } else {
            return filteredUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableFilter == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchViewCell")! as! SearchTableViewCell
            
            cell.delegate = self
            
            
            let bet = filtered[indexPath.row]
            
            cell.betQuestion.text = bet.betQuestion
            
            cell.firstBetOption.setTitle(bet.firstBetOption, for: .normal)
            cell.secondBetOption.setTitle(bet.secondBetOption, for: .normal)
            cell.typeOfGame.text = bet.typeOfGame
            
            print(bet)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userSearchCell")! as! UserSearchTableViewCell
            
            let user = filteredUsers[indexPath.row]
            cell.delegate = self
            
            var subTitleText = ""
            
            if user.numberOfBets != nil {
                subTitleText = "Has made " + String(user.numberOfBets!) + " bets"
            } else {
                subTitleText = "The user has made no bets"
            }
            
            UserService.getImageURL(userUID: user.uid) { (imageURL) in
                let url = URL(string: imageURL)
                let session = URLSession.shared
                
                session.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if let error = error {
                        print(error)
                    } else {
                        
                        DispatchQueue.main.async {
                            cell.profilePic.image = UIImage(data: data!)!
                        }
                    }
                }).resume()
            }
            
            cell.uid = user.uid
            
            cell.profilePic.image = #imageLiteral(resourceName: "default copy")
            cell.username.text = user.username
            cell.subTitle.text = subTitleText
            
            return cell
        }
        
    
    }
    
    
    func goToProfile(on cell: UserSearchTableViewCell) {
        passingUID = cell.uid
        
        let mainStoryboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        
        guard let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "otherUserProfile") as? OtherUserProfileViewController else {
            print("no vC found"); return}
        
        destinationVC.transferText = passingUID!
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
