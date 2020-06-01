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
			VStack(alignment: .leading){
				Text("Welcome to Shoo")
					.font(.system(.largeTitle, design: .rounded))
					.fontWeight(.bold)
				
				Text("Stop interruptions from every group in your life.")
					.font(.system(.title, design: .rounded))
					.fontWeight(.semibold)
					.fixedSize(horizontal: false, vertical: true)
					.foregroundColor(.secondary)
				
				Divider()

				Text("Shoo is easy.")
					.font(.system(.headline, design: .rounded))
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
				
				Spacer()
				
				HStack{
					Spacer()
					//Sign in with Apple
					ActivityIndicatorView(isPresented: $activityIndicatorInfo.isPresented, message: activityIndicatorInfo.message) {
						SignInWithAppleView(activityIndicatorInfo: self.$activityIndicatorInfo, alertInfo: self.$alertInfo).frame(width: 200, height: 50)
					}
					Spacer()
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
	
	struct SignInView_Previews: PreviewProvider {
		static var previews: some View {
			SignInView()
		}
	}
}
