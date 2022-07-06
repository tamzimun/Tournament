//
//  TournamentDetail.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 06.07.2022.
//

import Foundation

struct TournamentDetail: Codable {
    var id: Int
    var name: String
    var description: String
    var list: [List]
}

struct List: Codable {
    var login: String
    var firstName: String
    var lastName: String
    var major: String
}
