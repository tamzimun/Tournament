//
//  LoginViewController.swift
//  TournamentManager1
//
//  Created by tamzimun on 23.06.2022.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    var data: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }

    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleFilledButton(loginButton)
    }
    
    func validateField() -> String? {
        
        if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            guard let username = loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            let login = PersonLogin(login: username, password: password)

            
            networkManager.postLogin(credentials: login) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success(message):
                    
                    self!.data = message
                    let temp = message?.dropFirst().dropLast()
                    
                    let array = temp?.components(separatedBy: ",")
                    let separatedTokens = array![0].components(separatedBy: ":")
                    let token = separatedTokens[1].dropFirst().dropLast()
                    
                    let saveToken: Bool = KeychainWrapper.standard.set(String(token), forKey: "token")
                    
//                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ActiveTourViewController") as! ActiveTourViewController
//
//                    vc.token = String(token)
//                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                    self!.goToTournController()
                    print("\(String(describing: message)): 123")
                    
                case let .failure(error):
                    self!.showError("Unvalid login or password")
                    print("\(error): 456")
                }
            }
        }
    }
    
    func goToTournController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        // This is to get the SceneDelegate object from your view controller
        // root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
