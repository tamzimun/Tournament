//
//  MainViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let networkManager: NetworkManagerAF = .shared
    
    var tournaments: [TournamentDetails] = []
    {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTournaments()
        tableView.delegate = self
        tableView.dataSource = self
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.tournament = tournaments[indexPath.row]
        vc.tournamentId = tournaments[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController {
    private func loadTournaments() {
         //network request
        networkManager.loadTournaments { [weak self] tournaments in
            self?.tournaments = tournaments
            self?.loadTournaments()
        }
    }
}

