//
//  ActiveTourViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 04.07.2022.


import UIKit
import SwiftKeychainWrapper

class ActiveTourViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let networkManager: NetworkManagerAF = .shared
    
    var activeTournaments: [ActiveTournament] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadActiveTour()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ActiveTourViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTournaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveTourTableViewCell") as! ActiveTourTableViewCell
        
        cell.configure(with: activeTournaments[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailActiveTourViewController") as! DetailActiveTourViewController
//        vc.tournament = tournaments[indexPath.row]
        vc.tournamentId = activeTournaments[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ActiveTourViewController {
    private func loadActiveTour() {
         //network request
        let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
        networkManager.loadActiveTournaments(token: retrievedToken ?? "") { [weak self] activeTournaments in
            self?.activeTournaments = activeTournaments
        }
    }
}
