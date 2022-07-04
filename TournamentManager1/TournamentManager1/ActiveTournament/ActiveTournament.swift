//
//  ActiveTournament.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 04.07.2022.
//

import Foundation

struct ActiveTournaments: Codable {
    var id: Int
    var name: String
    var type: String
    var description: String
    var participants: Int
}
