//
//  ActiveTourTableViewCell.swift
//  TournamentManager1
//
//  Created by tamzimun on 04.07.2022.
//

import UIKit

class ActiveTourTableViewCell: UITableViewCell {

    @IBOutlet var tournamentImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var participantsLabel: UILabel!
    
    
    func configure(with tournament: ActiveTournament) {
        tournamentImageView.image = UIImage(named: "\(tournament.type).jpeg")
        if (UIImage(named: "\(tournament.type).jpeg") == nil){
            tournamentImageView.image = UIImage(named: "defaultBanner.jpeg")
        }
        titleLabel.text = tournament.name
        descriptionLabel.text = tournament.description
        participantsLabel.text = "\(tournament.participants)"
    }
}
