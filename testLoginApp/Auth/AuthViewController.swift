//
//  AuthViewController.swift
//  testLoginApp
//
//  Created by Андрий Пристайко on 20.07.2020.
//  Copyright © 2020 Андрий Пристайко. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

protocol LoginDelegate: NSObject {
    func didLogin(type: LoginType, name: String)
    func loginError(type: LoginType, error: Error)
}

enum LoginType {
    case facebook, google
}

class AuthViewController: UIViewController, LoginDelegate{
    
    let loginFB = LoginFB()
    let loginGoogle = LoginGoogle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.loginFB.delegate = self
        self.loginGoogle.delegate = self
        
        //add button FB
        let buttonFB = FBLoginButton()
        buttonFB.frame = CGRect(x: 16, y: 350, width: view.frame.width - 32, height: 60)
        buttonFB.delegate = loginFB
        buttonFB.permissions = ["email","public_profile"]
        self.view.addSubview(buttonFB)
        
        
        
        //add google sign in button
        let googleButton = GIDSignInButton(frame: CGRect(x: 16, y: 450, width: view.frame.width - 32, height: 0))
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance()?.delegate = loginGoogle
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func didLogin(type: LoginType, name: String) {
            self.dismiss(animated: true, completion: nil)
        }

        func loginError(type: LoginType, error: Error) {
            let title = type == .facebook ? "Unable to login to Facebook" : "Unable to login to Google"
            let alert = UIAlertController(title: title,
                                          message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }




