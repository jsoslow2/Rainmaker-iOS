//
//  CreateABetViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/2/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class CreateABetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CreateABetTableViewCellDelegate {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive = false
    var filtered : [String] = []
    var usernames : [String] = []
    var allUsers : [UsableUser]?
    
    var passingUID : String?
    var passingUsername : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Setup delegates */
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        searchBar.delegate = self as UISearchBarDelegate
        
        
        UserService.getAllUsersData { (allUsers) in
            self.allUsers = allUsers
            self.tableView.reloadData()
        }
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = usernames.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allUsers = allUsers {
            return allUsers.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createABetCell") as! CreateABetTableViewCell;
        
        cell.delegate = self
        
        guard let allUsers = allUsers else {
            return cell
        }
        
        let user = allUsers[indexPath.row]

        var numberOfBets = ""
        
        if user.numberOfBets != nil {
            numberOfBets = "Has made " + String(user.numberOfBets!) + " bets"
        } else {
            numberOfBets = "The user has made no bets"
        }
        
        
        cell.profilePic.image = user.profilePic
        cell.username.text = user.username
        cell.subLabel.text = numberOfBets
        cell.uid = user.uid

        return cell
    }
    
    //Segue to the complete create a bet view controller passing the username and uid to next view controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CompleteCreateABetViewController
        
        destinationVC.uid = passingUID
        destinationVC.username = passingUsername
    }
    
    
//    func goToCompleteCreateABet(on cell: CreateABetTableViewCell) {

//    }
    
    func goToCompleteCreateABet(on cell: CreateABetTableViewCell) {
                passingUID = cell.uid
                passingUsername = cell.username.text
                print("next test")
        
                self.performSegue(withIdentifier: "toCompleteCreateABet", sender: self)
    }
    
}

