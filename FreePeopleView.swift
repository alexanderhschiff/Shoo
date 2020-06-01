//
//  FreePeopleView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI



struct FreePeopleView: View {
	@EnvironmentObject var fire: Fire
		
	var messgage: String{
		var i = 0 //how many people are shoo or quiet
		
		for mate in self.fire.mates{
			if mate.status != 0{
				i += 1
			}
		}
		
		switch i{
		case 0:
			return "No need to shoo".uppercased()
		case 1:
			return "One person says shoo".uppercased()
		default:
			return "\(i) people say shoo".uppercased()
		}
	}
	
	var body: some View {
		Text(messgage)
		.font(.subheadline)
		.fontWeight(.semibold)
		.foregroundColor(.secondary)
	}
}
