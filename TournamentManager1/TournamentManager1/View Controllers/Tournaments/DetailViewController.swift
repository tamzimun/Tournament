//
//  DetailViewController.swift
//  TournamentManager1
//
//  Created by tamzimun on 23.06.2022.
//

import UIKit
import SwiftKeychainWrapper

class DetailViewController: UIViewController {
    
    var networkManager = NetworkManagerAF.shared
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var participantsLabel: UILabel!
    @IBOutlet var joinButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    private var timer: Timer!
    private var touraments: [TournamentLists] = []
    var tournament: TournamentLists?
    var tournamentId: Int?
    var data: String = ""
    
    var tournamentsDetail: TournamentDetail?
    
    private let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
    
    override func loadView() {
        super.loadView()
        loadTournamentsDetail()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUtilities()
        loadTournamentsDetail()
        navigationController?.delegate = self
        setViewContollerDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTournamentsDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTournamentsDetail()
    }
    
    
    func setViewContollerDetails() {
        if let tournament = tournament {
            imageView.image = UIImage(named: "\(tournament.type).jpeg")
            if (UIImage(named: "\(tournament.type).jpeg") == nil){
                imageView.image = UIImage(named: "defaultBanner.jpeg")
            }
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
                
                self!.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self!.setBackgroundColor), userInfo: nil, repeats: true)
                
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
                
                self!.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self!.setBackgroundColor), userInfo: nil, repeats: true)
                
            case let .failure(error):
                
                let alert = UIAlertController(title: "Error", message: "The tournament can only be started by its owner or must be at least two participants!", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self!.present(alert, animated: true, completion: nil)
                
                print("\(error): 456")
            }
        }
    }
    
    @objc
    func setBackgroundColor() {
        startButton.backgroundColor = .white
        joinButton.backgroundColor = .white
    }
}


extension DetailViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? MainViewController {
            controller.tableView.reloadData()
            controller.viewDidLoad()
        }
    }
}

extension DetailViewController {
    private func loadTournamentsDetail() {
         //network request
        let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
        
        networkManager.loadTournamentDetail(token: retrievedToken ?? "", id: (self.tournamentId)!) { [weak self] tournamentsDetail in
            self?.tournamentsDetail = tournamentsDetail
            
            if let tournamentsDetail = self!.tournamentsDetail {
                self!.titleLabel.text = tournamentsDetail.name
                self!.descriptionLabel.text = tournamentsDetail.description
                var temp: String = ""
                var enumeration: Int = 1
                for item in tournamentsDetail.list {
                    
                    temp += "\(enumeration).  \(item.lastName)  \(item.firstName)\n"
                    enumeration += 1
                }
                self!.participantsLabel.text = temp
                self!.title = tournamentsDetail.name
            }
        }
    }
}
