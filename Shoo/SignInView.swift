//
//  SignInView.swift
//  
//
//  Created by Benjamin Schiff on 5/19/20.
//
import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Welcome to Shoo")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Join a house and get started shooing your housemates! Sign in to get started")
                .font(.headline)
                .padding()
            
            ActivityIndicatorView(isPresented: $activityIndicatorInfo.isPresented, message: activityIndicatorInfo.message) {
                SignInWithAppleView(activityIndicatorInfo: self.$activityIndicatorInfo, alertInfo: self.$alertInfo).frame(width: 200, height: 50)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Activity Indicator
    @State private var activityIndicatorInfo = FireUIDefault.activityIndicatorInfo
    
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
    @State private var alertInfo = FireUIDefault.alertInfo
    
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
