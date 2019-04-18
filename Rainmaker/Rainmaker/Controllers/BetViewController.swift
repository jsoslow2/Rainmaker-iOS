//
//  BetViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/18/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BetViewController : UIViewController {
    
    @IBOutlet weak var typeOfGame: UILabel!
    @IBOutlet weak var betQuestion: UILabel!
    @IBOutlet weak var firstBetOption: UIButton!
    @IBOutlet weak var secondBetOption: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstBetOption.layer.cornerRadius = 20
        firstBetOption.backgroundColor = Constants.badGrey
        firstBetOption.addShadowView()
        
        secondBetOption.layer.cornerRadius = 20
        secondBetOption.backgroundColor = Constants.badGrey
        secondBetOption.addShadowView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func firstBetPressed(_ sender: Any) {
    }
    
    @IBAction func secondBetPressed(_ sender: Any) {
    }
    
}
