//
//  AddCharacterViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/27/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class AddCharacterViewController: DesignOfViewController, UITextFieldDelegate {
    
    var characterClass: String?
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {nameTextField.delegate = self}
    }
    var lastButtonPressed: UIButton?
    
    @IBOutlet weak var keyboardDistanceConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Set up so text field has a nice underline below it
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(white: 0.9, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width: nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        
        border.borderWidth = width
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
        nameTextField.textColor = Constants.textColor
        
        // Set up notification to change view when keyboard appears
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
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
    
    // Change view if keyboard appears
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardDistanceConstraint.constant = -(keyboardRectangle.height)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCharacter(_ sender: UIButton) {
        characterClass = sender.titleLabel?.text
      //  sender.backgroundColor = Constants.buttonColor
       // sender.setTitleColor(UIColor.white, for: UIControlState.normal)
        var classSelectedImageTitle = ""
        var classUnselecteddImageTitle = ""
        switch characterClass {
        case "Bard":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Cleric":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Druid":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Fighter":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Paladin":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Ranger":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Rogue":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Sorcerer":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Warlock":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        case "Wizard":
            classSelectedImageTitle = "Class_Fighter_Selected"
            classUnselecteddImageTitle = "Class_Fighter"
        default:
            break
        }
        sender.setImage((UIImage(named: classSelectedImageTitle)), for: UIControlState.normal)
        if lastButtonPressed != sender {
           // lastButtonPressed?.backgroundColor = nil
           // lastButtonPressed?.setTitleColor(Constants.buttonColor, for: UIControlState.normal)
            lastButtonPressed?.setImage((UIImage(named: classUnselecteddImageTitle)), for: UIControlState.normal)
            lastButtonPressed = sender
        }
        checkSaveButton()
    }
    
    
    
}
