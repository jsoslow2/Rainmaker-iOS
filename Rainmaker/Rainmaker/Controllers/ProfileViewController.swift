//
//  ProfileViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 12/5/18.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    let mintGreen = (UIColor(red: 0.494, green: 0.831, blue: 0.682, alpha: 1.0))
    let badGrey = (UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1.0))
    
    
    var bets : [ProfileBet]?
    var createdBets : [ConfirmBet]?
    let userID = Auth.auth().currentUser!.uid
    var username: String?
    var profileImage: UIImage?
    var imageURL: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var totalBetsLabel: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var createdBetsButton: UIButton!
    @IBOutlet weak var activeBetsButton: UIButton!
    
    
    var tableFilter : Int = 0
    @IBOutlet weak var tableView: UITableView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        UserService.getAllUsers { (boop) in
            print("")
            
        }
        
        //enable tapping on propic
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangeProfilePic)))

        
        //allocate delegate and datasource
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        //make propic circular
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        profilePic.clipsToBounds = true
        
        //add divider line at the top of the table view
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        
       
        //get current money
        BetService.getCurrentMoney { (money) in
            if let money = money {
                User.currentMoney = money
            }
        }
        
        //get the username and set the username
        UserService.getUsername(userUID: userID) { (theName) in
            self.username = theName

            self.name.text = self.username
        }
        
        //set the total bets and current money labels
        totalBetsLabel.text = String(User.numberOfBets)
        totalMoney.text = "$" + String(User.currentMoney)
        
        //LOAD THE DATA
        //load active bets
        BetService.getUsersActiveBets(userID: userID) { (allBets) in
                self.bets = allBets.reversed()
                self.tableView.reloadData()
            }
        
        //load created bets
        BetService.getUsersCreatedBets(userID: userID) { (createdBets) in
            self.createdBets = createdBets.reversed()
            self.tableView.reloadData()
            print(createdBets)
        }
        ////
        
        //load the propic
        UserService.getImageURL(userUID: userID) { (imageURL) in
            self.imageURL = imageURL
            
            let url = URL(string: imageURL)
            let session = URLSession.shared
            
            session.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    
                    DispatchQueue.main.async {
                        self.profilePic.image = UIImage(data: data!)
                    }
                }
            }).resume()
        }
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    @IBAction func createdBets(_ sender: Any) {
        tableFilter = 0
        createdBetsButton.backgroundColor = mintGreen
        activeBetsButton.backgroundColor = badGrey
        tableView.reloadData()
        tableView.rowHeight = 120
    }
    
    @IBAction func activeBets(_ sender: Any) {
        tableFilter = 1
        createdBetsButton.backgroundColor = badGrey
        activeBetsButton.backgroundColor = mintGreen
        tableView.reloadData()
        tableView.rowHeight = 80
    }
    
    
}

extension ProfileViewController: UITableViewDataSource, CustomBetConfirmationDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableFilter == 0 {
            //created bets
            if let createdBets = createdBets {
                return createdBets.count
            } else {
                return 0
            }
        } else {
            //active bets
            if let bets = bets {
                return bets.count
            } else {
                return 0
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableFilter == 0 {
            ///CREATED BETS
            let cell = tableView.dequeueReusableCell(withIdentifier: "customBetResultConfirmationCell")! as! CustomBetResultConfirmationTableViewCell
            
            guard let createdBets = createdBets else {return cell}
            
            cell.delegate = self
            
            let bet = createdBets[indexPath.row]
            
            cell.betQuestion.text = bet.betQuestion!
            cell.firstOption.setTitle(bet.firstBetOption!, for: .normal)
            cell.secondOption.setTitle(bet.secondBetOption!, for: .normal)
            cell.betKey = bet.betKey
            
            return cell
            
        } else {
            ///ACTIVE BETS
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileBetCell")! as! ProfileBetTableViewCell
            
            guard let bets = bets else {return cell}
            
            let bet = bets[indexPath.row]
            
            cell.betQuestion.text = bet.betQuestion
            cell.betAmount.text = "$" + String(bet.betAmount)
            cell.typeOfGame.text = bet.typeOfGame
            
            BetService.getInfoOfBet(betKey: bet.betKey) { (a, b, firstBetOption, secondBetOption, c, d, e, f) in
                if bet.chosenBet == 0 {
                    cell.typeOfGame.text = firstBetOption
                } else {
                    cell.typeOfGame.text = secondBetOption
                }
            }
            
            if bet.rightAnswer == bet.chosenBet {
                cell.winLoss.text = "W"
            } else if bet.isActive == 1 {
                cell.winLoss.text = "NA"
                cell.winLoss.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            } else {
                cell.winLoss.text = "L"
                cell.winLoss.textColor = #colorLiteral(red: 1, green: 0.356, blue: 0.192, alpha: 1)
            }
            
            
            return cell
        }
        }
        
    func resultsConfirmed(which button: Int, on cell: CustomBetResultConfirmationTableViewCell) {
        BetService.confirmResultsOfBet(betKey: cell.betKey!, userID: userID, rightAnswer: button) { (bool) in
            print(bool)
        }
        print("this function has been called")
    }
        

    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleChangeProfilePic () {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] {
            profileImage = editedImage as? UIImage
        } else if let originalImage = info[.originalImage] {
            profileImage = originalImage as? UIImage
        }
        
        if let finalImage = profileImage {
            profilePic.image = finalImage
        }
        
        uploadImage()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImage () {
        let storageRef = Storage.storage().reference().child("\(userID).png")
        
        if let uploadData = self.profileImage!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    
                    if let error = error {
                        print(error)
                        print("Oh no an error!")
                    } else {
                        UserService.adjustProfilePic(userUID: self.userID, imageURL: (url?.absoluteString)!, completion: { (bool) in
                            print(bool)
                            print("woohoo")
                        })
                    }
                })
            }
        }
    }
}
