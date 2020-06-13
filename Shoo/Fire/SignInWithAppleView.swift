//
//  SignInWithAppleView.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import UIKit


@available(iOS 13.0, *)
class SignInWithAppleButton: UIControl {
    var cornerRadius: CGFloat = 10.0 { didSet { updateRadius() } }
    private var target: Any?
    private var action: Selector?
    private var controlEvents: UIControl.Event = .touchUpInside
    private lazy var whiteButton = ASAuthorizationAppleIDButton(type: .continue, style: .white)
    private lazy var blackButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    init() {
        super.init(frame: CGRect.infinite)
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.target = target
        self.action = action
        self.controlEvents = controlEvents
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupButton()
    }
}

// MARK: - Private Methods
@available(iOS 13.0, *)
private extension SignInWithAppleButton {
    func setupButton() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            subviews.forEach { $0.removeFromSuperview() }
            addSubview(whiteButton)
            whiteButton.cornerRadius = cornerRadius
            whiteButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
            action.map { whiteButton.addTarget(target, action: $0, for: controlEvents) }
        case _:
            subviews.forEach { $0.removeFromSuperview() }
            addSubview(blackButton)
            blackButton.cornerRadius = cornerRadius
            blackButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
            action.map { blackButton.addTarget(target, action: $0, for: controlEvents) }
        }
    }
    
    func updateRadius() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            whiteButton.cornerRadius = cornerRadius
        case _:
            blackButton.cornerRadius = cornerRadius
        }
    }
}



struct SignInWithAppleView: UIViewRepresentable {
    
    @EnvironmentObject var fire: Fire
    @Environment(\.colorScheme) var colorScheme
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> SignInWithAppleButton {
        let button = SignInWithAppleButton()
         
        button.addTarget(context.coordinator, action:  #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: SignInWithAppleButton, context: Context) {
        //uiView.setNeedsDisplay()
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        let parent: SignInWithAppleView?
        
        // Unhashed nonce.
        var currentNonce: String?
        
        init(_ parent: SignInWithAppleView) {
            self.parent = parent
            super.init()
        }
        
        @objc func didTapButton() {
            #if !targetEnvironment(simulator)
            parent?.startActivityIndicator(message: "Signing up with Apple...")
            let nonce = FireAuth.randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName]
            request.nonce = FireAuth.sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            #endif
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            let vc = UIApplication.shared.windows.last?.rootViewController
            return (vc?.view.window!)!
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            guard let parent = parent else {
                fatalError("No parent found")
            }
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    parent.stopActivityIndicator()
                    parent.presentAlert(title: "Error", message: "Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    parent.stopActivityIndicator()
                    parent.presentAlert(title: "Error", message: "Unable to serialize token string from data")
                    return
                }
                
                parent.updateActivityIndicator(message: "Logging in...")
                FireAuth.signIn(providerID: FireAuth.providerID.apple, idTokenString: idTokenString, nonce: nonce) { (result) in
                    switch result {
                    case .success(let authDataResult):
                        let signInWithAppleResult = (authDataResult, appleIDCredential)
                        FireAuth.handle(signInWithAppleResult) { (result) in
                            switch result {
                            case .success(let profile):
                                print("Successfully Signed in with Apple into Firebase: \(profile)")
                                parent.stopActivityIndicator()
                            case .failure(let err):
                                print(err.localizedDescription)
                                parent.stopActivityIndicator()
                                parent.presentAlert(title: "Error", message: err.localizedDescription)
                            }
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                        parent.stopActivityIndicator()
                        parent.presentAlert(title: "Error", message: err.localizedDescription)
                    }
                }
                
            } else {
                parent.stopActivityIndicator()
                parent.presentAlert(title: "Error", message: "No Apple ID Credential found")
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            guard let parent = parent else {
                fatalError("No parent found")
            }
            parent.stopActivityIndicator()
            parent.presentAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    // MARK: - Activity Indicator
    @Binding var activityIndicatorInfo: ActivityIndicatorInfo
    
    func startActivityIndicator(message: String) {
        activityIndicatorInfo.message = message
        activityIndicatorInfo.isPresented = true
    }
    
    func stopActivityIndicator() {
        activityIndicatorInfo.isPresented = false
    }
    
    func updateActivityIndicator(message: String) {
        stopActivityIndicator()
        startActivityIndicator(message: message)
    }
    
    // MARK: - Alert
    @Binding var alertInfo: AlertInfo
    
    func presentAlert(title: String, message: String, actionText: String = "Ok", actionTag: Int = 0) {
        alertInfo.title = title
        alertInfo.message = message
        alertInfo.actionText = actionText
        alertInfo.actionTag = actionTag
        alertInfo.isPresented = true
    }
    
    func executeAlertAction() {
        switch alertInfo.actionTag {
        case 0:
            print("No action alert action")
            
        default:
            print("Default alert action")
        }
    }
}

