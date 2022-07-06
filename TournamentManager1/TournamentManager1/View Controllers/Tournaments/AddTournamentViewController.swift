//
//  AddTournamentViewController.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import UIKit
import SwiftKeychainWrapper

protocol AddTournamentDelegate: AnyObject {
    func addTournament(tournament: TournamentLists)
}

class AddTournamentViewController: UIViewController {
    
    private let networkManager: NetworkManagerAF = .shared
    
    @IBOutlet var tournamentNameField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var tournamentPickerView: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var errorLbl: UILabel!
    
    weak var addDelegate: AddTournamentDelegate?
    
    private var chooseTournament: String = ""
    private let tournaments: [String] = ["MortalCombat", "Fifa", "Tenis","UFC"]
    private var cellIndex: Int?
    private let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tournamentPickerView.delegate = self
        tournamentPickerView.dataSource = self
        chooseTournament = tournaments[0]
        setUpElements()
    }
    
    func setUpElements() {
        
        errorLbl.alpha = 0
        Utilities.styleFilledButton(saveButton)
        tournamentPickerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.9)
        
        descriptionField.font = UIFont(name: "verdana", size: 16.5)
        descriptionField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionField.layer.borderWidth = 0.5
        descriptionField.clipsToBounds = true
        descriptionField.textColor = UIColor.systemGray3
        descriptionField.becomeFirstResponder()
        descriptionField.selectedTextRange = descriptionField.textRange(from: descriptionField.beginningOfDocument, to: descriptionField.beginningOfDocument)
        descriptionField.delegate = self
    }
    
    func validateField() -> String? {
        
        if tournamentNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }

        return nil
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            guard let tournamentName = tournamentNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let description = descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            let tournament = chooseTournament
            
            let tourToSend = AddTournament(name: tournamentName, type: tournament, description: description)
            
            networkManager.postTournaments(token: retrievedToken ?? "", credentials: tourToSend) { [weak self] result in
                    guard self != nil else { return }
                    switch result {
                    case let .success(message):
                        print(message?.description ?? "")
                        print("Pushed new tournament")
                        print("\(String(describing: message)): 123")
                        self!.navigationController?.popViewController(animated: true)
                    case let .failure(error):
                        self!.showError("This tournament has already created, please choose another tournament.")
                        print("Somthing went wrong \(error)")
                    }
                }
        }
    }
    
    func showError(_ message: String) {
        errorLbl.text = message
        errorLbl.alpha = 1
    }
}

extension AddTournamentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        tournaments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = tournaments[row]
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseTournament = tournaments[row]
    }
}

extension AddTournamentViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Enter tournament description"
            textView.textColor = UIColor.systemGray3
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

         else if textView.textColor == UIColor.systemGray3 && !text.isEmpty {
            textView.font = UIFont(name: "verdana", size: 16.0)
            textView.textColor = UIColor.black
            textView.text = text
         }
        else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.systemGray3 {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
