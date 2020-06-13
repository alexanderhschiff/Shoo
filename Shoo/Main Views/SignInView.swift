//
//  SignInView.swift
//
//
//  Created by Benjamin Schiff on 5/19/20.
//
import SwiftUI

struct SignInView: View {
    /*
     @State private var place = 0
     let places = ["house", "dorm", "apartment", "fam", "place", "group", "wherever"]
     
     let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
     */
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .center){
                Spacer()
                
                Text("Welcome to Shoo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Stop interruptions from every group in your life")
                    .font(.title)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                
                Spacer()
                Spacer()
                
                Text("Tell your housemates, roommates, officemates, or friends to Shoo when you can't be bothered. If you want, you can let them know what you're up to, say for how long you'll be this way, and even send notifications to everyone to ensure peace and quiet.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).foregroundColor(Color(UIColor.tertiarySystemBackground)))
                
                Spacer()
                
                VStack(alignment: .center){
                    Group{
                    Text("End the chaos by creating a free and anonymous account")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    Image(systemName: "arrow.down")
                    }.accessibility(label: Text("Create account"))
                    
                    ActivityIndicatorView(isPresented: $activityIndicatorInfo.isPresented, message: activityIndicatorInfo.message) {
                        SignInWithAppleView(activityIndicatorInfo: self.$activityIndicatorInfo, alertInfo: self.$alertInfo).frame(width: 200, height: 50).cornerRadius(10)
                    }.accessibility(label: Text("Sign in with Apple"))
                        .accessibility(hint: Text("Sign up"))
                    
                    VStack{
                        Text("By creating an account and using the Shoo app, you're agreeing to our ")
                        HStack(spacing: 0){
                            Button("privacy policy") {
                                buttonPressHaptic(false)
                                let url: NSURL = URL(string: "https://www.shoo.app/privacy_policy.html")! as NSURL
                                UIApplication.shared.open(url as URL)
                            }
                            Text(" and ")
                            Button(" terms & conditions") {
                                buttonPressHaptic(false)
                                let url: NSURL = URL(string: "https://www.shoo.app/terms_and_conditions.html")! as NSURL
                                UIApplication.shared.open(url as URL)
                            }
                            Text(".")
                        }
                    }
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20, style: .continuous).foregroundColor(Color(UIColor.tertiarySystemBackground)))
                
                
                
                /*
                 Divider()
                 
                 
                 Text("Shoo is easy.")
                 .font(.headline)
                 .padding(.top)
                 
                 HStack{
                 Image(systemName: "person.badge.plus.fill")
                 Text("1. Create a profile with the button below.")
                 .font(.system(.body, design: .rounded))
                 }
                 
                 HStack{
                 Image(systemName: "person.3.fill")
                 Text("2. Join a group.")
                 .font(.system(.body, design: .rounded))
                 }
                 
                 HStack{
                 Image(systemName: "person.3.fill")
                 Text("3. Update your status often.")
                 .font(.system(.body, design: .rounded))
                 }
                 
                 HStack{
                 Image(systemName: "clock.fill")
                 Text("4. Ahhh. Peace.")
                 .font(.system(.body, design: .rounded))
                 }
                 */
            }
            .padding()
            .frame(minHeight: UIScreen.main.bounds.height)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .edgesIgnoringSafeArea(.all)
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
    
    struct SignInView_Previews: PreviewProvider {
        static var previews: some View {
            SignInView().environment(\.colorScheme, .light)
        }
    }
}
