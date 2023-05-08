//
//  MainViewController.swift
//  TournamentManager1
//
//  Created by tamzimun on 23.06.2022.
//

import UIKit
import SwiftKeychainWrapper

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let networkManager: NetworkManagerAF = .shared
    
    var tournaments: [TournamentLists] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        loadTournaments()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTournaments()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTournaments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTournaments()
    }
    
    @IBAction func addTournament(_ sender: UIBarButtonItem) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddTournamentViewController") as? AddTournamentViewController
        navigationController?.pushViewController(controller!, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentTableViewCell") as! TournamentTableViewCell
        
        cell.configure(with: tournaments[indexPath.row])
        cell.nameLabel.isHidden = false
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.tournament = tournaments[indexPath.row]
        vc.tournamentId = tournaments[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.reloadData()
    }
}

extension MainViewController {
    private func loadTournaments() {
         //network request
        let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
        
        networkManager.loadTournaments(token: retrievedToken ?? "") { [weak self] tournaments in
            self?.tournaments = tournaments
            self?.tableView.reloadData()
        }
    }
}
