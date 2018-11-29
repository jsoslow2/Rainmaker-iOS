//
//  HomeViewController.swift
//  Rainmaker
//
//  Created by Eugene Enclona on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homePosts: [HomePost]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BetService.getCurrentMoney { (money) in
            if let money = money {
                User.currentMoney = money
            }
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
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
        /*
        if let homePosts = homePosts {
            return homePosts.count
        } else {
            return 0
        }
         */

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell")! as! HomeFeedTableViewCell
        
        /*
        let homePost = homePosts![indexPath.row]
        
        
        let betKey = homePost.betKey
        let chosenBet = homePost.chosenBet
        let friendsKey = homePost.friendsKey
 
         */
        //get bet data based on bet key and friends key then pass it to the cell label

        return cell;
    }
    
    
    
}
