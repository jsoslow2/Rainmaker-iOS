//
//  OtherUserProfileTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 2/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

protocol OtherUseProfileTableViewCellDelegate : class {
    func goToBet(on cell: OtherUserProfileTableViewCell)
}

class OtherUserProfileTableViewCell : UITableViewCell {
    
    @IBOutlet weak var winLoss: UILabel!
    @IBOutlet weak var betQuestion: UILabel!
    @IBOutlet weak var typeOfGame: UILabel!
    @IBOutlet weak var betAmount: UILabel!
    var betState: Int?
    var chosenOption: Int?
    var rightAnswer: Int?
    var betKey : String?
    
    var delegate : OtherUseProfileTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(OtherUserProfileTableViewCell.goToBet(sender:)))
        addGestureRecognizer(tapGesture)
        
        setState()
        
        if let betState = betState {
            if betState == -1 {
                winLoss.text = "NA"
                winLoss.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            } else if betState == 0 {
                winLoss.text = "L"
                winLoss.textColor = #colorLiteral(red: 0.988, green: 0.3607843137, blue: 0.231372549, alpha: 1)
            } else {
                winLoss.text = "W"
                winLoss.textColor = #colorLiteral(red: 0.4941176471, green: 0.831372549, blue: 0.6823529412, alpha: 1)
            }
        } else {
            winLoss.text = "NA"
            winLoss.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setState() {
        if rightAnswer == -1 {
            betState = -1
        } else if rightAnswer == chosenOption {
            betState = 1
        } else {
            betState = 0
        }
    }
    
    @objc func goToBet(sender: UITapGestureRecognizer) {
        delegate?.goToBet(on: self)
    }
    
}
