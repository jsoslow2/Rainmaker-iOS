//
//  Storyboard+Utility.swift
//  Rainmaker
//
//  Created by Jack Soslow on 11/27/18.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum RMType: String {
        case main
        case login
        
        var filename: String {
            return rawValue.capitalized
        }
       
    }
    convenience init(type: RMType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: RMType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
    
}
