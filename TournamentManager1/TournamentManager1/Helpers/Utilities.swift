//
//  Utilities.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleFilledButton(_ button: UIButton) {
        
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButtenTapped(_ button: UIButton) {

        let customCollor = #colorLiteral(red: 1, green: 0.3158529401, blue: 0.002163501224, alpha: 1)
        button.backgroundColor = customCollor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton) {
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleHollowBorderButton(_ button: UIButton) {
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    
    static func isPasswordValid(_ password: String) -> Bool {
        
        let passwordText = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{3,}$")
        return passwordText.evaluate(with: password)
    }
}
