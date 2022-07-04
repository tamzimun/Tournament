//
//  ProfileViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 04.07.2022.
//

import UIKit

class ProfileViewController: UIViewController {


    @IBOutlet var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        // after user has successfully logged out
  
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let authorizationNavController = storyboard.instantiateViewController(identifier: "AuthorizationNavController")

    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authorizationNavController)
    }
    
    
}
