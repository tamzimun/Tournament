//
//  ProfileViewController.swift
//  TournamentManager1
//
//  Created by tamzimun on 04.07.2022.
//

import UIKit
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {

    var networkManager = NetworkManagerAF.shared
    
    @IBOutlet var firstNamelabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!

    
    @IBOutlet var logOutButton: UIButton!
    
    var userInfo: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileInfo()
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        // after user has successfully logged out
  
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let authorizationNavController = storyboard.instantiateViewController(identifier: "AuthorizationNavController")

    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authorizationNavController)
    }
    
    
}

extension ProfileViewController {
    private func loadProfileInfo() {
         //network request

        networkManager.loadProfileInfo() { [weak self] userInfo in
            self?.userInfo = userInfo
            
            self!.firstNamelabel.text = "Firstname: \(userInfo.firstName)"
            self!.lastNameLabel.text = "Lastname: \(userInfo.lastName)"
            self!.loginLabel.text = "Login: \(userInfo.login)"
            self!.majorLabel.text = "Login: \(userInfo.major)"
        }
    }
}

