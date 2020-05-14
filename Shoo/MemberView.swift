//
//  MemberView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct MemberView: View {
	
	let name: String
	let status: Int
	let reason: String
	
	var body: some View {
		ZStack{
			Color.white
			HStack{
				StoplightView(color: self.status)
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
		.frame(maxWidth: .infinity)
		.frame(height: 150)
		.cornerRadius(20)
		.shadow(radius: 20, y: 10)
	}
}

struct MemberView_Previews: PreviewProvider {
	static var previews: some View {
		MemberView(name: "Alex", status: 0, reason: "Watching TV")
	}
}
