//
//  ViewController.swift
//  testLoginApp
//
//  Created by Андрий Пристайко on 19.07.2020.
//  Copyright © 2020 Андрий Пристайко. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        nameLabel.text = Auth.auth().currentUser?.displayName
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
}

