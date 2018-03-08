//
//  AddCharacterViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/27/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class AddCharacterViewController: UIViewController {
    
    var characterChoice: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCharacter(_ sender: UIButton) {
        characterChoice = sender.titleLabel?.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterSpells" {
            
        }
    }
    
}
