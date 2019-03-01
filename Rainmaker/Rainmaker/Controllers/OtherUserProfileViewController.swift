//
//  OtherUserProfileViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 2/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class OtherUserProfileViewController: UIViewController {
    
    var testText = ""
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(testText)
        testLabel.text = testText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

