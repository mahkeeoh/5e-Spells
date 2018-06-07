//
//  AddCharacterViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/27/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class AddCharacterViewController: UIViewController, UITextFieldDelegate {
    
    var characterClass: String?
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {nameTextField.delegate = self}
    }
    var lastButtonPressed: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    // Check to see if save button should be active
    func checkSaveButton() {
        if (lastButtonPressed != nil) && (nameTextField.text != "") {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        checkSaveButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }

    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCharacter(_ sender: UIButton) {
        characterClass = sender.titleLabel?.text
        sender.backgroundColor = UIColor.cyan
        if lastButtonPressed != sender {
            lastButtonPressed?.backgroundColor = nil
            lastButtonPressed = sender
        }
        checkSaveButton()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CharacterSpells" {
            return true
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterSpells" {
            
        }
    }
    
}
