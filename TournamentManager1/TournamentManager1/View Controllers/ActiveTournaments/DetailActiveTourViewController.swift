//
//  ActiveTourDetailViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 04.07.2022.
//

import UIKit

class DetailActiveTourViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var firstPlaceLabel: UILabel!
    @IBOutlet var secondPlaceLabel: UILabel!
    @IBOutlet var thirdPlaceLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var tournamentId: Int!
    var leaders: [Leader] = []
    var temp1: Int = 0
    var temp2: Int = 0
    var temp3: Int = 0
    
    var threeTopResults: [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadActiveTour()
        setLeaderBoard()
    }
    
    func setLeaderBoard() {
        
        let greatestChampion = threeTopResults.sorted { $0.value > $1.value }.prefix(3)
        for (key,value) in greatestChampion {
            print("my name is \(value)")
            if value == temp1 {
                firstPlaceLabel.text = key
            } else if value < temp2 {
                secondPlaceLabel.text = key
            } else if value < temp3 {
                thirdPlaceLabel.text = key
            }
        }
    }
}

extension DetailActiveTourViewController {
    private func loadActiveTour() {
        networkManager.loadLeaderBoard(id: tournamentId) { [weak self] leaders in
            self?.leaders = leaders
            for leader in leaders {
                self!.threeTopResults["\(leader.name) \(leader.surname)"] = leader.score
            }
        }
    }
}
