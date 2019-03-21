//
//  CustomBetResultConfirmationTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/20/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

protocol CustomBetConfirmationDelegate : class {
    func resultsConfirmed(which button: Int, on cell: CustomBetResultConfirmationTableViewCell)
}

class CustomBetResultConfirmationTableViewCell : UITableViewCell {
    
    @IBOutlet weak var betQuestion: UILabel!
    @IBOutlet weak var firstOption: UIButton!
    @IBOutlet weak var secondOption: UIButton!
    var betKey : String?
    
    
    var delegate: CustomBetConfirmationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstOption.layer.cornerRadius = 10
        secondOption.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func firstButtonPressed(_ sender: Any) {
        delegate?.resultsConfirmed(which: 0, on: self)
        print("first button pressed")
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        delegate?.resultsConfirmed(which: 1, on: self)
        print("second button pressed")
    }
    
}

