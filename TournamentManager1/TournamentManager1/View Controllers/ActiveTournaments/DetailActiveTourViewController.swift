//
//  ActiveTourDetailViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 04.07.2022.
//

import UIKit
import SwiftKeychainWrapper

class DetailActiveTourViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var firstPlaceLabel: UILabel!
    @IBOutlet var secondPlaceLabel: UILabel!
    @IBOutlet var thirdPlaceLabel: UILabel!
    @IBOutlet var firstPlaceScoreLabel: UILabel!
    @IBOutlet var secondPlaceScoreLabel: UILabel!
    @IBOutlet var thirdPlaceScoreLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    private var tournamentsDetail: [TournamentDetail] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var tournamentsBrackets: [TournamentBracket] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tournamentId: Int!
    var leaders: [Leader] = []
    var temp1: Int = 0
    var temp2: Int = 0
    var temp3: Int = 0
    
    var threeTopResults: [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadActiveTour()
        loadTournamentBracket()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DetailActiveTourViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournamentsBrackets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentBracketTableViewCell") as! TournamentBracketTableViewCell
        
        for rounds in tournamentsBrackets[indexPath.row].roundList {
            cell.roundLabel.text = "Round \(rounds.stage)"
            
            for gamers in rounds.matches {
                cell.firstGamerLabel.text = gamers.username1
                cell.secondGamerLabel.text = gamers.username2
                cell.winnerLabel.text = "winner: \(gamers.winner)"
                for user in leaders {
                    if "\(user.surname) \(user.name)" == gamers.username1 {
                        cell.firstGamerScoreLabel.text = "\(user.score) -"
                    } else if "\(user.surname) \(user.name)" == gamers.username2 {
                        cell.secondGamerScoreLabel.text = "\(user.score) -"
                    } else {
                        cell.firstGamerScoreLabel.text = "0 -"
                        cell.secondGamerScoreLabel.text = "0"
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        vc.tournament = tournamentsBracket[indexPath.row]
//        vc.tournamentId = tournaments[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailActiveTourViewController {
    private func loadActiveTour() {
        networkManager.loadLeaderBoard(id: tournamentId) { [weak self] leaders in
            self?.leaders = leaders
        for leader in leaders {
            self!.threeTopResults["\(leader.name) \(leader.surname)"] = leader.score
        }
            let greatestChampion = self!.threeTopResults.sorted { $0.value > $1.value }.prefix(3)
            for (key,value) in greatestChampion {
                if value > self!.temp1 {
                    self!.firstPlaceLabel.text = key
                    self!.firstPlaceScoreLabel.text = "\(value)"
                } else if value < self!.temp2 {
                    self!.secondPlaceLabel.text = key
                    self!.secondPlaceScoreLabel.text = "\(value)"
                } else if value < self!.temp3 {
                    self!.thirdPlaceLabel.text = key
                    self!.thirdPlaceScoreLabel.text = "\(value)"
                }
            }
        }
    }
}

extension DetailActiveTourViewController {
    private func loadTournamentBracket() {
         //network request
        
        networkManager.loadTournamentBracket(id: tournamentId) { [weak self] tournamentsBracket in
            self?.tournamentsBrackets = [tournamentsBracket]
            print("my tournamentsDetail is \(tournamentsBracket)")
            self?.tableView.reloadData()
        }
    }
}




