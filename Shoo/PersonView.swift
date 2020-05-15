//
//  MemberView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

enum Status{
	case red, yellow, green
}

struct PersonView: View {
	
	let name: String
	let status: Status
	let reason: String
	
	var body: some View {
		ZStack{
			Color.gray
				.opacity(0.3)
				.blur(radius: 1)
			HStack{
				VStack(alignment: .leading){
					Text(self.name)
						.font(.largeTitle)
						.fontWeight(.heavy)
					Text(self.reason.uppercased())
						.font(.subheadline)
						.fontWeight(.semibold)
						.foregroundColor(.secondary)
						.offset(y: -5)
					Spacer()
				}
				Spacer()
			}
			.padding()
		}
		.frame(width: 250, height: 120)
		.cornerRadius(20)
		.shadow(radius: 5, x: 1, y: 4)
	}
}

struct PersonView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack{
			/*LinearGradient(gradient: Gradient(colors: [.blue, .red, .white]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)*/
			
			PersonView(name: "Alexander", status: .red, reason: "📺 Watching TV")
		}
		
	}
}
