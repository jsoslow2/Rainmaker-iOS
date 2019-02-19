//
//  HomeViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 25/11/2018.
//


//TODO Redo Homepage

import UIKit

class HomeViewController: UIViewController {
    
    var homePosts: [HomePost]?

    @IBOutlet weak var moneyButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        BetService.getCurrentMoney { (money) in
            if let money = money {
                User.currentMoney = money
            }
            
            self.moneyButton.title = "$" + String(User.currentMoney)
        }
        
        UserService.getNumberOfBets(userUID: User.current.uid) { (num) in
            User.numberOfBets = num
        }
        
        //load profile info now 
        BetService.getUsersActiveBets(userID: User.current.uid) { (bets) in
            User.activeBets = bets
        }
        
        
        UserService.getNumberOfBets(userUID: User.current.uid) { (num) in
            print(num)
        }
        
        //LOAD THE DATA
        BetService.getHomeFeedBets { (homepost) in
            self.homePosts = homepost
            self.tableView.reloadData()
        }
        
    }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homePosts = homePosts?.reversed()
        
        if let homePosts = homePosts?.reversed() {
            return homePosts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell")! as! HomeFeedTableViewCell

        guard let homePosts = homePosts else {return cell}
        
        let post = homePosts[indexPath.row]
        
        
        func chosenAnswer () -> String {
            if (post.chosenBet == 0) {
                return post.firstOption!
            } else {
                return post.secondOption!
            }
        }
        
        let titleText = NSAttributedString(string: (post.username! + " bet " + chosenAnswer()))
        let boldUsername  = post.username!
        let boldAnswer = chosenAnswer()
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedUsername = NSMutableAttributedString(string:boldUsername, attributes:attrs)
        let attributedAnswer = NSMutableAttributedString(string:boldAnswer, attributes:attrs)
        
        let normalText = " bet "
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedUsername.append(normalString)
        attributedUsername.append(attributedAnswer)
        
        
        
        
        cell.topLabel.attributedText = attributedUsername
        cell.subLabel.text = post.typeOfGame
        cell.betTitle.text = post.betQuestion
        cell.profilePicture.image = post.image
        cell.leftButton.setTitle(post.firstOption, for: .normal)
        cell.rightButton.setTitle(post.secondOption, for: .normal)
        
        

        return cell
    }
}

