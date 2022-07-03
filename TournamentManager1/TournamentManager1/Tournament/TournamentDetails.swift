//
//  TournamentDetails.swift
//  TournamentManager1
//
//  Created by Рахим Лугма on 23.06.2022.
//

import Foundation
import UIKit

struct TournamentDetails: Codable {
    var id: Int
    var type: String
    var status: String
    var description: String
    var participants: Int
}

struct TournamentDto: Codable {
    var name: String
    var type: String
    var description: String
    
}

struct TournamentMain {
    var id: Int
    var name: String
    var type: String
    var description: String
}




