//
//  ActiveTourTableViewCell.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 04.07.2022.
//

import UIKit

class ActiveTourTableViewCell: UITableViewCell {

    @IBOutlet var tournamentImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    
    func configure(with tournament: ActiveTournaments) {
        tournamentImageView.image = UIImage(named: "\(tournament.type).jpeg")
        if (UIImage(named: "\(tournament.type).jpeg") == nil){
            tournamentImageView.image = UIImage(named: "defaultBanner.jpeg")
        }
        titleLabel.text = tournament.name
    }
}
