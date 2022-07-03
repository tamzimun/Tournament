//
//  LoginViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import UIKit

class LoginViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
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
                    
                    print("\(String(describing: message)): 123")
                    
                case let .failure(error):
                    self!.showError("Unvalid login or password")
                    print("\(error): 456")
                }
            }
            transitionToMainView()
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToMainView() {

        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        self.navigationController?.pushViewController(homeViewController!, animated: true)
    }
}
