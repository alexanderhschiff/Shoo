//
//  SignInView.swift
//
//
//  Created by Benjamin Schiff on 5/19/20.
//
import SwiftUI

struct SignInView: View {
    /*
    @State private var place = 0
    let places = ["house", "dorm", "apartment", "fam", "place", "group", "wherever"]
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    */
    
    var body: some View {
        VStack(alignment: .center){
            Text("Order in the house")
                .font(.largeTitle)
                .fontWeight(.bold)
            /*
            Text(places[place%places.count])
            .font(.largeTitle)
            .fontWeight(.bold)
            .lineLimit(1)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: true, vertical: false)
            .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.25), {
            self.place += 1
            })
            }
            */
            
            Text("Welcome to Shoo")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 0){
                VStack(alignment: .leading, spacing: 5){
                    Text("1. Start or join a house")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "person.badge.plus.fill")
                            .font(.headline)
                        
                        Text("Simply scan or present a unique QR code")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10){
                    Text("2. Set your status:")
                        .font(.headline)
                        .fontWeight(.bold)
                    HStack {
                        Text("Free")
                            .statusButtonStyle(color: Color.green)
                        Text("Down to hang.")
                    }
                    HStack {
                        Text("Quiet")
                            .statusButtonStyle(color: Color.yellow)
                        Text("Busy, but could be interrupted.")
                    }
                    HStack {
                        Text("Shoo")
                            .statusButtonStyle(color: Color.red)
                        Text("Please, leave me alone.")
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10){
                    VStack(alignment: .leading, spacing: 5){
                        Text("3. Say what's happening:")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Choose presets or create your own excuse")
                            .font(.subheadline)
                    }
                    HStack{
                        Text("👩‍💻 Working")
                            .reasonStyle()
                        Text("📺 Watching TV")
                            .reasonStyle()
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10){
                    VStack(alignment: .leading, spacing: 5){
                        Text("4. And for how long:")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Anywhere between 10 minutes and all day")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            
            VStack(spacing: 0){
                Text("Sounds good. Let's go.")
                    .font(.headline)
                    .fontWeight(.bold)
                
                //Sign in with Apple
                ActivityIndicatorView(isPresented: $activityIndicatorInfo.isPresented, message: activityIndicatorInfo.message) {
                    SignInWithAppleView(activityIndicatorInfo: self.$activityIndicatorInfo, alertInfo: self.$alertInfo).frame(width: 200, height: 50)
                }
            }
        }
        .padding()
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
