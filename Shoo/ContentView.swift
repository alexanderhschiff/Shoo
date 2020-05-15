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
			.padding()
	}
}

extension View{
	func reasonStyle() -> some View{
		ZStack{
			Color.white
				.opacity(0.8)
				.blur(radius: 1)
			self.modifier(Reason())
		}
		.frame(height: 50)
		.cornerRadius(20)
		.shadow(radius: 5, y: 2)
	}
}


struct ContentView: View {
	@State private var backgroundColor = Color.red
	var freePeople = 3
		
	var body: some View {
		VStack(alignment: .leading){
			VStack(alignment: .leading){
				HStack{
					Text("Home")
						.fontWeight(.heavy)
						.font(.largeTitle)
					Spacer()
					Image(systemName: "person.badge.plus.fill")
						.font(.title)
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
			
			Text("Your status")
				.font(.title)
				.fontWeight(.bold)
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
			
			Spacer()
		}
		
		
		
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
