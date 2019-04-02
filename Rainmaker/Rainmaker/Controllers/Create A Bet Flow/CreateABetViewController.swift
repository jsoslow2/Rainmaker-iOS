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
    var filtered : [UsableUser] = []
    var usernames : [String] = []
    var allUsers : [UsableUser]?
    
    var passingUID : String?
    var passingUsername : String?
    
    var currentUsername: String?
    var currentUID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        /* Setup delegates */
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        searchBar.delegate = self as UISearchBarDelegate
        
        
        UserService.getAllUsersData { (allUsers) in
            self.allUsers = allUsers
            self.filtered = allUsers
            self.tableView.reloadData()
        }
        
        UserService.getUsername(userUID: currentUID)  { (username) in
            self.currentUsername = username
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {filtered = allUsers!
            tableView.reloadData(); return}
        
        filtered = (allUsers?.filter({ (UsableUser) -> Bool in
            UsableUser.username.lowercased().contains(searchText.lowercased())
        }))!
        dump(allUsers)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createABetCell") as! CreateABetTableViewCell;
        
        cell.delegate = self
        
        
        let user = filtered[indexPath.row]

        var numberOfBets = ""
        
        if user.numberOfBets != nil {
            numberOfBets = "Has made " + String(user.numberOfBets!) + " bets"
        } else {
            numberOfBets = "The user has made no bets"
        }
        
        //load the profile picture
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
    
    @IBAction func adminGoToNext(_ sender: Any) {
        if currentUsername == "jsoslow2" {
            passingUID = ""
            passingUsername = ""
            self.performSegue(withIdentifier: "toCompleteCreateABet", sender: self)
        }
    }
    

    
    func goToCompleteCreateABet(on cell: CreateABetTableViewCell) {
                passingUID = cell.uid
                passingUsername = cell.username.text
                print("next test")
        
                self.performSegue(withIdentifier: "toCompleteCreateABet", sender: self)
    }
    
}

