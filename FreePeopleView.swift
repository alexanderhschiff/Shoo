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
		var i = 0
		
		for mate in self.fire.mates{
			if mate.status == 0{
				i += 1
			}
		}
		
		switch i{
		case 0:
			return "Nobody is free 😕"
		case 1:
			return "One person is free 🤩"
		default:
			return "\(i) people are free 😁"
		}
	}
	
	var body: some View {
		Text(messgage)
		.font(.headline)
		.foregroundColor(.secondary)
	}
}
