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
    var passingUID: String?

    @IBOutlet weak var moneyButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var isLoadingViewController = false
    
    
    //enabling tableview to load when tab bar is switched
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoadingViewController = true
        viewLoadSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLoadingViewController {
            isLoadingViewController = false
        } else {
            viewLoadSetup()
        }
    }
    
    func viewLoadSetup() {
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
            self.homePosts = homepost.reversed()
            self.tableView.reloadData()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)

        tableView.reloadData()

    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }

}

extension HomeViewController: UITableViewDataSource, HomeFeedTableViewCellDelegate, UIGestureRecognizerDelegate {
    
    
    func didTapBetButton(which button: Int, on cell: HomeFeedTableViewCell) {
        
        guard let bets = homePosts, let indexPath = self.tableView.indexPath(for: cell)
            else { return }
        
        let bet = bets[indexPath.row]
        
        func chosenOption () -> String {
            if button == 0 {
                return bet.firstOption!
            } else {
                return bet.secondOption!
            }
        }
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to bet $5 on " + chosenOption() + " ?", preferredStyle: .alert)
        
        let dialogMessage2 = UIAlertController(title: "Error", message: "You have already placed a bet on this!", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK",  style: .default, handler: { (action) -> Void in
            
            //if ok, you do the bet
            BetService.bet(withBetKey: bet.betKey, chosenBet: button, withBetAmount: 5) { (bool) in
                if !bool {
                    self.present(dialogMessage2, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
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
        
        if let homePosts = homePosts {
            return homePosts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell")! as! HomeFeedTableViewCell
        
        cell.delegate = self

        guard let homePosts = homePosts else {return cell}
        
        let post = homePosts[indexPath.row]
        
        
        func chosenAnswer () -> String {
            if (post.chosenBet == 0) {
                return post.firstOption!
            } else {
                return post.secondOption!
            }
        }
        
        
        
        
        let boldUsername  = post.username!
        let boldAnswer = chosenAnswer()
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedUsername = NSMutableAttributedString(string:boldUsername, attributes:attrs)
        let attributedAnswer = NSMutableAttributedString(string:boldAnswer, attributes:attrs)
        
        let normalText = " bet "
        let normalString = NSMutableAttributedString(string:normalText)
        
        let extraText = " with "
        let extraString = NSMutableAttributedString(string: extraText)
        
        let boldOtherUsername = NSMutableAttributedString(string: post.otherUsername!, attributes: attrs)
        
        attributedUsername.append(normalString)
        attributedUsername.append(attributedAnswer)
        
        cell.betKey = post.betKey
        cell.userID = post.UID
        
        if post.createBet == 0 {
            cell.topLabel.attributedText = attributedUsername
        } else {
            
            attributedUsername.append(extraString)
            attributedUsername.append(boldOtherUsername)
            
            cell.topLabel.attributedText = attributedUsername
        }
        
        //load the profile picture
        UserService.getImageURL(userUID: post.UID) { (imageURL) in
            let url = URL(string: imageURL)
            let session = URLSession.shared
            
            session.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    
                    DispatchQueue.main.async {
                        cell.profilePicture.image = UIImage(data: data!)
                    }
                }
            }).resume()
        }
        
        
        cell.subLabel.text = post.typeOfGame
        cell.betTitle.text = post.betQuestion
        cell.profilePicture.image = post.image
        cell.leftButton.setTitle(post.firstOption, for: .normal)
        cell.rightButton.setTitle(post.secondOption, for: .normal)
        
        

        return cell
    }
    
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toOtherUserProfile" {
            let destinationVC = segue.destination as! OtherUserProfileViewController
            
            // set a variable in the second view controller with the data to pass
            destinationVC.transferText = passingUID!
        }


    }
    
    @objc func goToProfile(on cell: HomeFeedTableViewCell) {
        // Segue to the second view controller
        passingUID = cell.userID
        print("going to profile")
        self.performSegue(withIdentifier: "toOtherUserProfile", sender: self)
    }
    

    @IBAction func unwindToHome (_ sender: UIStoryboardSegue) {}

}

