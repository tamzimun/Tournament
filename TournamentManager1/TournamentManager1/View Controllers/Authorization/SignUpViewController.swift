//
//  SignUpViewController.swift
//  TournamentManager1
//
//  Created by tamzimun on 23.06.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var majorPickerView: UIPickerView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var checkPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    private var chooseMajor: String = ""
    private let majors: [String] = ["Java", "Frontend", "IOS", "Android", "DevOPs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        majorPickerView.delegate = self
        majorPickerView.dataSource = self
        chooseMajor = majors[0]
    }
    
    func setUpElements() {

        errorLabel.alpha = 0
        Utilities.styleFilledButton(signUpButton)
        majorPickerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.9);
    }
    
    func validateField() -> String? {
        
        if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            checkPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your passsword is at least 8 characters, contains a special character and a number."
        }
        
        if passwordTextField.text != checkPasswordTextField.text {
            return "Passwords are not the same."
        }
        return nil
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            guard let login = loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let firstname = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let lastname = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            let major = chooseMajor
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

            let register = PersonSignUp(login: login, name: firstname, surname: lastname, major: major, password: password)
            
            networkManager.postRegister(credentials: register) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success(message):
                    self!.transitionToHome()
                    // some toastview to show that user is registered
                    print("\(String(describing: message)): 123")
                case let .failure(error):
                    print("\(error): 456")
                }
            }
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        self.navigationController?.popViewController(animated: true)
        view.window?.makeKeyAndVisible()
    }
}


extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        majors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = majors[row]
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseMajor = majors[row]
    }
}
