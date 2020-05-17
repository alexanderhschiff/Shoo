//
//  SignIn.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/16/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation
import FirebaseUI
import UIKit

class SignInVC: UIViewController, FUIAuthDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.showUserInfo(user:user)
            } else {
                self.showLoginVC()
            }
        }
    }
    
    func showUserInfo(user:User) { }
    func showLoginVC() {
        let authUI = FUIAuth.defaultAuthUI()
        let provider = FUIOAuth.appleAuthProvider()
        let providers = [provider]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        authUI?.delegate = self
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //Do something if implementing
    }

}




