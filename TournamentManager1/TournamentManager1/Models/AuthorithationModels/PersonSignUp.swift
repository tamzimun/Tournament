//
//  PersonSignUp.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import Foundation

struct PersonSignUp: Encodable {
    var login: String
    var name: String
    var surname: String
    var major: String
    var password: String
}
