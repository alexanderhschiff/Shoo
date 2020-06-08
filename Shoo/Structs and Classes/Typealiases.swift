//
//  Typealiases.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import FirebaseAuth
import AuthenticationServices


typealias SignInWithAppleResult = (authDataResult: AuthDataResult, appleIDCredential: ASAuthorizationAppleIDCredential)

public enum Status: Int {
    case green = 0
    case yellow = 1
    case red = 2
}
