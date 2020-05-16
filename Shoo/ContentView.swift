//
//  ContentView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct Reason: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.headline)
			.padding()	}
}

extension View{
	func reasonStyle() -> some View{
		ZStack(alignment: .leading){
			Color.gray
				.opacity(0.3)
				.blur(radius: 1)
			self.modifier(Reason())
		}
		.frame(width: 250, height: 50)
		.cornerRadius(20)
		.shadow(radius: 5, y: 5)
	}
}

struct ContentView: View {
	@State private var backgroundColor = Color.red
	@State private var addUserView = false
	var freePeople = 3
	
	@State private var time: Int = 10
	var displayTime: String{
		switch time{
		case 0:
			return "10 minutes"
		case 1:
			return "15 minutes"
		case 2:
			return "20 minutes"
		case 3:
			return "30 minutes"
		case 4:
			return "45 minutes"
		case 5:
			return "1 hour"
		case 6:
			return "2 hours"
		case 7:
			return "3 hours"
		case 8:
			return "4 hours"
		case 9:
			return "A while"
		case 10:
			return "All day"
		default:
			return "A while"
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0){
			VStack(alignment: .leading){
				HStack{
					Text("Home")
						.fontWeight(.heavy)
						.font(.largeTitle)
					Spacer()
					Image(systemName: "person.badge.plus.fill")
						.font(.title)
						.onTapGesture {
							self.addUserView = true
					}
				}
				FreePeopleView(freePeople: self.freePeople)
					.font(.headline)
					.offset(y: -10)
			}
			.padding([.horizontal, .top])
			
			ScrollView(.horizontal, showsIndicators: false){
				HStack{
					ForEach(0..<4){ _ in
						PersonView(name: "Alexander", status: .red, reason: "👨‍💻 Working")
					}
				}
				.padding()
			}
			
			VStack(alignment: .leading){
				Text("Your status")
					.font(.title)
					.fontWeight(.bold)
				
				Text("What's happening")
					.font(.subheadline)
			}
			.padding(.horizontal)
			
			ScrollView(.horizontal, showsIndicators: false){
				HStack{
					ForEach(0..<10){ _ in
						VStack(alignment: .leading){
							Text("👩‍💻 Working")
								.reasonStyle()
							Text("📱 On the phone")
								.reasonStyle()
						}
					}
				}
				.padding(.horizontal)
				.padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
			}
			
			Text("For how long?")
				.font(.subheadline)
				.padding(.horizontal)
			
			VStack(alignment: .leading, spacing: 0){
				HStack{
					Image(systemName: "timer")
					Text("\(self.displayTime)")
						.font(.headline)
						.fontWeight(.bold)
				}
				TimeSliderView(time: $time)
			}
			.padding()
			
			Spacer()
		}
        .sheet(isPresented: $addUserView){
            SignInView()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
