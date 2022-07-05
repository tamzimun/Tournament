//
//  DetailViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import UIKit
import SwiftKeychainWrapper

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
    var data: String = ""
    
    private let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
    
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
    }
    
    func setUpUtilities() {
        
        Utilities.styleHollowBorderButton(joinButton)
        Utilities.styleHollowBorderButton(startButton)
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        
        guard let tournamentId = tournamentId else {
            return
        }
        
        networkManager.postJoinTour(token: retrievedToken ?? "", id: tournamentId) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(message):
                print("\(String(describing: message)): 123")
                
                Utilities.styleFilledButtenTapped(self!.joinButton)
            case let .failure(error):
                
                let alert = UIAlertController(title: "Error", message: "You have already joined!", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self!.present(alert, animated: true, completion: nil)
                print("\(error): 456")
            }
        }
        
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        guard let tournamentId = tournamentId else {
            return
        }

        networkManager.postStartTour(token: retrievedToken ?? "", id: tournamentId) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(message):
                print("\(String(describing: message)): 123")
                
                Utilities.styleFilledButtenTapped(self!.startButton)
            case let .failure(error):
                
                let alert = UIAlertController(title: "Error", message: "The tournament can only be started by the one who created it!!", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self!.present(alert, animated: true, completion: nil)
                print("\(error): 456")
            }
        }
    }
}


