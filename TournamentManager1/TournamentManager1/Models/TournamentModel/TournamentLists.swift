//
//  TournamentDetails.swift
//  TournamentManager1
//
//  Created by Рахим Лугма on 23.06.2022.
//

import Foundation
import UIKit

struct TournamentLists: Codable {
    var id: Int
    var name: String
    var type: String
    var description: String
    var participants: Int
}

struct AddTournament: Encodable {
    var name: String
    var type: String
    var description: String
    
}







