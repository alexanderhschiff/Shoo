//
//  EditCardView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct EditCardView: View {
	
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
		VStack(alignment: .leading){
			VStack(alignment: .center){
				RoundedRectangle(cornerRadius: 20)
					.foregroundColor(Color.gray)
					.frame(width: 50, height: 5)
					.opacity(0.5)
			}
			.frame(width: UIScreen.main.bounds.width)
			.padding(.vertical)
			
			PersonView(name: "Alex", status: 2, reason: "👩‍💻 Working", endTime: Date().addingTimeInterval(9000))
				.frame(width: UIScreen.main.bounds.width, alignment: .center)
				.padding(.bottom)
			
			VStack(alignment: .center, spacing: 0){
				Text("Your status")
					.font(.title)
					.fontWeight(.bold)
				
				GeometryReader { geo in
					HStack{
						RoundedRectangle(cornerRadius: 20)
							.frame(width: geo.size.width/4, height: 50)
							.foregroundColor(Color.green)
							.overlay(Text("Free"))
						RoundedRectangle(cornerRadius: 20)
							.frame(width: geo.size.width/4, height: 50)
							.foregroundColor(Color.yellow)
							.overlay(Text("Not now"))
						RoundedRectangle(cornerRadius: 20)
							.frame(width: geo.size.width/4, height: 50)
							.foregroundColor(Color.red)
							.overlay(Text("Shoo"))
						
					}
					.font(.headline)
					.foregroundColor(Color.white)
				}.frame(height: 50)
			}
			Text("What's happening")
				.font(.subheadline)
				.padding(.horizontal)
			
			ScrollView(.horizontal, showsIndicators: false){
				HStack{
					ForEach(0..<10){ _ in
						VStack(alignment: .leading){
							Text("👩‍💻 Working")
								.reasonStyle()
							HStack{
								Image(systemName: "plus")
								Text("Custom")
								
							}.reasonStyle()
						}
					}
				}
				.padding(.horizontal)
			}
			
			VStack(alignment: .leading){
				Text("For how long?")
					.font(.subheadline)
				
				HStack{
					Image(systemName: "timer")
					Text("\(self.displayTime)")
						.font(.headline)
						.fontWeight(.bold)
				}
				TimeSliderView(time: self.$time)
					.frame(height: 60)
					.offset(y: 5)
			}
			.padding([.bottom, .horizontal])
			
			
			/*
			GeometryReader{ buttons in
			HStack{
			Text("Update silently")
			.foregroundColor(Color.white)
			.padding()
			.background(Color.blue)
			.cornerRadius(20)
			Spacer()
			Text("Update & notify")
			.foregroundColor(Color.white)
			.padding()
			.background(Color.red)
			.cornerRadius(20)
			}
			}
			.padding()*/
		}
	}
}

struct EditCardView_Previews: PreviewProvider {
	static var previews: some View {
		EditCardView()
	}
}
