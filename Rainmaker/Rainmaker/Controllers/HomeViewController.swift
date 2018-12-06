//
//  HomeViewController.swift
//  Rainmaker
//
//  Created by Eugene Enclona on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//


//TODO Redo Homepage

import UIKit

class HomeViewController: UIViewController {
    
    var homePosts: [HomePost]?
    var hasBetOnSearch = false
    var viewWillAppearCount = 0

    @IBOutlet weak var tableView: UITableView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewWillAppearCount = viewWillAppearCount + 1
        
        if viewWillAppearCount == 2 {
            hasBetOnSearch = true
            
            self.navigationItem.leftBarButtonItem?.title = "+$90"
            tableView.reloadData()
            
          
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
        
        return 5
        
        /*
        if let homePosts = homePosts {
            return homePosts.count
        } else {
            return 0
        }
         */

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var row = indexPath.row
        if hasBetOnSearch {
            row = row - 1
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell")! as! HomeFeedTableViewCell
        
        switch row {
            
        case -1:
            cell.betTitle.text = "Who will win the game?"
            cell.leftButton.setTitle("PENN", for: .normal)
            cell.rightButton.setTitle("PRINCETON", for: .normal)
            cell.leftButton.backgroundColor = .green
            cell.subLabel.text = "Ivy League"
            
            let boldedName = attributedText(withString: "Jack Soslow bet the PENN", boldString: "Jack Soslow", font: UIFont.init(name: "Avenir Book", size: CGFloat.init(integerLiteral: 17))!)
            
            cell.topLabel.attributedText = boldedName
            
            cell.profilePicture.image = UIImage(named: "Jack")!
            
        case 0:
            cell.betTitle.text = "Who will win the game?"
            cell.leftButton.setTitle("Eagles", for: .normal)
            cell.rightButton.setTitle("Giants", for: .normal)
            cell.subLabel.text = "NFL - Eagles v Giants"
            
            let boldedName = attributedText(withString: "Andrew Ciatto bet the Eagles", boldString: "Andrew Ciatto", font: UIFont.init(name: "Avenir Book", size: CGFloat.init(integerLiteral: 17))!)
            
            cell.topLabel.attributedText = boldedName
            
            cell.profilePicture.image = UIImage(named: "Andrew")!
            
        case 1:
            cell.betTitle.text = "Who will win the game?"
            cell.leftButton.setTitle("Patriots", for: .normal)
            cell.rightButton.setTitle("Jets", for: .normal)
            cell.subLabel.text = "NFL - Patrios v Jets"
            
            let boldedName = attributedText(withString: "RJ Bora bet the Patriots", boldString: "RJ Bora", font: UIFont.init(name: "Avenir Book", size: CGFloat.init(integerLiteral: 17))!)
            
            cell.topLabel.attributedText = boldedName
            
            cell.profilePicture.image = UIImage(named: "RJ")!
            
        case 2:
            cell.betTitle.text = "Who will win the game?"
            cell.leftButton.setTitle("Indianapolis", for: .normal)
            cell.rightButton.setTitle("Jacksonville", for: .normal)
            cell.subLabel.text = "NFL - Indianapolis v Jacksonville"
            
            let boldedName = attributedText(withString: "Tej Singh bet the Jacksonville", boldString: "Tej Singh", font: UIFont.init(name: "Avenir Book", size: CGFloat.init(integerLiteral: 17))!)
            
            cell.topLabel.attributedText = boldedName
            
            cell.profilePicture.image = UIImage(named: "Tej")!
            
        default:
            cell.isHidden = true
            return cell
        }

        print(cell)
        return cell;
    }
    

    //used for bolding some parts of string
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    
}
