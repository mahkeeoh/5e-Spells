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
    var characterImageString: String?
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {nameTextField.delegate = self}
    }
    var lastButtonPressed: UIButton?
    
    @IBOutlet weak var keyboardDistanceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bardButton: UIButton!
    @IBOutlet weak var clericButton: UIButton!
    @IBOutlet weak var druidButton: UIButton!
    @IBOutlet weak var fighterButton: UIButton!
    @IBOutlet weak var paladinButton: UIButton!
    @IBOutlet weak var rangerButton: UIButton!
    @IBOutlet weak var rogueButton: UIButton!
    @IBOutlet weak var sorcererButton: UIButton!
    @IBOutlet weak var warlockButton: UIButton!
    @IBOutlet weak var wizardButton: UIButton!
    
    var buttonArray = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // add buttons to array
        buttonArray = [bardButton, clericButton, druidButton, fighterButton, paladinButton, rangerButton, rogueButton, sorcererButton, warlockButton, wizardButton]
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.navigationBar.tintColor = Constants.tabColor
        
        // Set up so text field has a nice underline below it
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(white: 0.9, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width: nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        
        border.borderWidth = width
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
        nameTextField.textColor = Constants.textColor
        
//        // Set up notification to change view when keyboard appears
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: NSNotification.Name.UIKeyboardWillShow,
//            object: nil
//        )
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
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            keyboardDistanceConstraint.constant = -(keyboardRectangle.height)
//            UIView.animate(withDuration: 0.5) {
//                self.view.layoutIfNeeded()
//            }
//        }
//    }

    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCharacter(_ sender: UIButton) {
        
        lastButtonPressed = sender
        characterClass = sender.titleLabel?.text
        for buttonLabel in buttonArray {
            let buttonLabelClass = buttonLabel.titleLabel?.text
            if lastButtonPressed?.titleLabel?.text == buttonLabelClass {
                var classSelectedImageTitle = ""
                switch buttonLabelClass {
                    case "Bard":
                        classSelectedImageTitle = "Class_Bard_Selected"
                        characterImageString = "Class_Bard_Rounded"
                    case "Cleric":
                        classSelectedImageTitle = "Class_Cleric_Selected"
                        characterImageString = "Class_Cleric_Rounded"
                    case "Druid":
                        classSelectedImageTitle = "Class_Druid_Selected"
                        characterImageString = "Class_Druid_Rounded"
                    case "Fighter":
                        classSelectedImageTitle = "Class_Fighter_Selected"
                        characterImageString = "Class_Fighter_Rounded"
                    case "Paladin":
                        classSelectedImageTitle = "Class_Paladin_Selected"
                        characterImageString = "Class_Paladin_Rounded"
                    case "Ranger":
                        classSelectedImageTitle = "Class_Ranger_Selected"
                        characterImageString = "Class_Ranger_Rounded"
                    case "Rogue":
                        classSelectedImageTitle = "Class_Rogue_Selected"
                        characterImageString = "Class_Rogue_Rounded"
                    case "Sorcerer":
                        classSelectedImageTitle = "Class_Sorcerer_Selected"
                        characterImageString = "Class_Sorcerer_Rounded"
                    case "Warlock":
                        classSelectedImageTitle = "Class_Warlock_Selected"
                        characterImageString = "Class_Warlock_Rounded"
                    case "Wizard":
                        classSelectedImageTitle = "Class_Wizard_Selected"
                        characterImageString = "Class_Wizard_Rounded"
                    default:
                        break
                    }
                buttonLabel.setImage(UIImage(named: classSelectedImageTitle), for: .normal)
            }
            else {
                var classUnselectedImageTitle = ""
                switch buttonLabelClass {
                    case "Bard":
                        classUnselectedImageTitle = "Class_Bard"
                    case "Cleric":
                        classUnselectedImageTitle = "Class_Cleric"
                    case "Druid":
                        classUnselectedImageTitle = "Class_Druid"
                    case "Fighter":
                        classUnselectedImageTitle = "Class_Fighter"
                    case "Paladin":
                        classUnselectedImageTitle = "Class_Paladin"
                    case "Ranger":
                        classUnselectedImageTitle = "Class_Ranger"
                    case "Rogue":
                        classUnselectedImageTitle = "Class_Rogue"
                    case "Sorcerer":
                        classUnselectedImageTitle = "Class_Sorcerer"
                    case "Warlock":
                        classUnselectedImageTitle = "Class_Warlock"
                    case "Wizard":
                        classUnselectedImageTitle = "Class_Wizard"
                    default:
                        break
                }
                
                buttonLabel.setImage(UIImage(named: classUnselectedImageTitle), for: .normal)
                
            }
        }
        
        checkSaveButton()
        
//        characterClass = sender.titleLabel?.text
//        var classSelectedImageTitle = ""
//        var classUnselecteddImageTitle = ""
//        switch characterClass {
//        case "Bard":
//            classSelectedImageTitle = "Class_Bard_Selected"
//            characterImageString = "Class_Bard_Selected"
//            classUnselecteddImageTitle = "Class_Bard"
//        case "Cleric":
//            classSelectedImageTitle = "Class_Cleric_Selected"
//            characterImageString = "Class_Cleric_Selected"
//            classUnselecteddImageTitle = "Class_Cleric"
//        case "Druid":
//            classSelectedImageTitle = "Class_Druid_Selected"
//            characterImageString = "Class_Druid_Selected"
//            classUnselecteddImageTitle = "Class_Druid"
//        case "Fighter":
//            classSelectedImageTitle = "Class_Fighter_Selected"
//            characterImageString = "Class_Fighter_Selected"
//            classUnselecteddImageTitle = "Class_Fighter"
//        case "Paladin":
//            classSelectedImageTitle = "Class_Paladin_Selected"
//            characterImageString = "Class_Paladin_Selected"
//            classUnselecteddImageTitle = "Class_Paladin"
//        case "Ranger":
//            classSelectedImageTitle = "Class_Ranger_Selected"
//            characterImageString = "Class_Ranger_Selected"
//            classUnselecteddImageTitle = "Class_Ranger"
//        case "Rogue":
//            classSelectedImageTitle = "Class_Rogue_Selected"
//            characterImageString = "Class_Rogue_Selected"
//            classUnselecteddImageTitle = "Class_Rogue"
//        case "Sorcerer":
//            classSelectedImageTitle = "Class_Sorcerer_Selected"
//            characterImageString = "Class_Sorcerer_Selected"
//            classUnselecteddImageTitle = "Class_Sorcerer"
//        case "Warlock":
//            classSelectedImageTitle = "Class_Warlock_Selected"
//            characterImageString = "Class_Warlock_Selected"
//            classUnselecteddImageTitle = "Class_Warlock"
//        case "Wizard":
//            classSelectedImageTitle = "Class_Wizard_Selected"
//            characterImageString = "Class_Wizard_Selected"
//            classUnselecteddImageTitle = "Class_Wizard"
//        default:
//            break
//        }
//
//        sender.setImage((UIImage(named: classSelectedImageTitle)), for: UIControlState.normal)
//        if lastButtonPressed != sender {
//           // lastButtonPressed?.backgroundColor = nil
//           // lastButtonPressed?.setTitleColor(Constants.buttonColor, for: UIControlState.normal)
//            lastButtonPressed?.setImage((UIImage(named: classUnselecteddImageTitle)), for: UIControlState.normal)
//            lastButtonPressed = sender
//        }
//        checkSaveButton()
//    }
    }
    
    
}
