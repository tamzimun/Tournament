//
//  ActiveTournament.swift
//  TournamentManager1
//
//  Created by tamzimun on 04.07.2022.
//

import Foundation

struct ActiveTournament: Codable {
    var id: Int
    var name: String
    var type: String
    var description: String
    var participants: Int
}
