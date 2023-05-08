//
//  Participant.swift
//  TournamentManager1
//
//  Created by tamzimun on 04.07.2022.
//

import Foundation
import UIKit

struct TournamentBracket: Decodable {
    var id: Int
    var name: String
    var type: String
    var description: String
    var startedDate: String
    var finishedDate: String
    var roundList: [Stage]
}

struct Stage: Decodable {
    var stage: Int
    var matches: [Users]
}

struct Users: Decodable {
    var username1: String
    var username2: String
    var winner: String?
}

