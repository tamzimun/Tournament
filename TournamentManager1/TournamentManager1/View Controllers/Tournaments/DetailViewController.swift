//
//  DetailViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var networkManager = NetworkManagerAF.shared
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var participantsLabel: UILabel!
    @IBOutlet var joinButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    private var touraments: [TournamentDetails] = []
    var tournament: TournamentDetails?
    var tournamentId: Int?
    private var gameId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUtilities()
        
        if let tournament = tournament {
            imageView.image = UIImage(named: "\(tournament.type).jpeg")
            if (UIImage(named: "\(tournament.type).jpeg") == nil){
                imageView.image = UIImage(named: "defaultBanner.jpeg")
            }
            titleLabel.text = tournament.type
            descriptionLabel.text = tournament.description
            participantsLabel.text = "Participants: \(tournament.participants)"
            title = tournament.type
        }
//        loadTournaments(id: tournamentId!)
    }
    
    func setUpUtilities() {
        Utilities.styleHollowBorderButton(joinButton)
        Utilities.styleHollowBorderButton(startButton)
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
    }
    
}

//extension DetailViewController {
//
//    private func loadTournaments(id: Int) {
//        networkManager.loadTournamentsMainID(id: id){ [weak self] tournaments in
//            self?.tournament = tournaments
//        }
//    }
//}
