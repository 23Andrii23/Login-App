//
//  LoginGoogle.swift
//  testLoginApp
//
//  Created by Андрий Пристайко on 21.07.2020.
//  Copyright © 2020 Андрий Пристайко. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class LoginGoogle: NSObject, GIDSignInDelegate {
    weak var delegate: LoginDelegate?

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            self.delegate?.loginError(type: .google, error: error!)
            return
        }

        guard let authentication = user.authentication else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        //create user in Firebase
        Auth.auth().signIn(with: credential) {[weak self] (user, error) in
            if let err = error {
                self?.delegate?.loginError(type: .google, error: err)
                return
            }
            //add user to database
            guard let user = user, let email = user.user.email else {
                return
            }
            let ref = Database.database().reference().child("users")
            ref.child(user.user.uid).updateChildValues(["name": user.user.displayName ?? "", "email": email])

            self?.delegate?.didLogin(type: .google, name: user.user.displayName ?? "")
        }
    }
}

