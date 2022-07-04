//
//  TournamentTableViewCell.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import UIKit


class TournamentTableViewCell: UITableViewCell {


    @IBOutlet var tounamentImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var participants: UILabel!
    
    func configure(with tournament: TournamentDetails) {
        tounamentImageView.image = UIImage(named: "\(tournament.type).jpeg")
        if (UIImage(named: "\(tournament.type).jpeg") == nil){
            tounamentImageView.image = UIImage(named: "defaultBanner.jpeg")
        }
        nameLabel.text = tournament.type
        descriptionLabel.text = tournament.description
        participants.text = "\(tournament.participants)"
    }
}
