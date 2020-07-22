//
//  LoginFB.swift
//  testLoginApp
//
//  Created by Андрий Пристайко on 21.07.2020.
//  Copyright © 2020 Андрий Пристайко. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class LoginFB: NSObject, LoginButtonDelegate {

    weak var delegate: LoginDelegate?
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
    //Log In FB
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let result = result, result.isCancelled == false else { return }

        if error == nil {
            GraphRequest(graphPath: "me", parameters:["fields":"email,name"] , tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET")).start { (nil, result, error) in
                if error == nil {
                    print(result!)
                    //add user to database
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    Auth.auth().signIn(with: credential) { (result, error) in
                        guard let result = result else { return }
                        if error == nil {
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name":result.user.displayName as Any,"email": result.user.email as Any])
                            self.delegate?.didLogin(type: .facebook, name: result.user.displayName ?? "")

                            }
                        }
                    }
                }
            }
        }
}

