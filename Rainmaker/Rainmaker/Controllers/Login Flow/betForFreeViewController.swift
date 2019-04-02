//
//  betForFreeViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class betForFreeViewController : UIViewController {
    
    var username : String?
    
    @IBOutlet weak var continueButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 20
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
            
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? FinalOnboardingViewController
        destinationVC?.username = username
    }
    
}
