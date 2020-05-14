//
//  StoplightView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct StoplightView: View {
	
	let color: Int
	let radius:CGFloat = 20
	
	var body: some View {
		VStack{
			Circle()
				.fill(Color.red)
				.frame(width: color == 0 ? 1.5 * radius : radius, height: color == 0 ? 1.5 * radius : radius)
				.shadow(radius: color == 0 ? 20 : 0)
				.opacity(color == 0 ? 1 : 0.7)
			Circle()
				.fill(Color.yellow)
				.frame(width: color == 1 ? 1.5 * radius : radius, height: color == 1 ? 1.5 * radius : radius)
				.shadow(radius: color == 1 ? 20 : 0)
				.opacity(color == 1 ? 1 : 0.7)
			Circle()
				.fill(Color.green)
				.frame(width: color == 2 ? 1.5 * radius : radius, height: color == 2 ? 1.5 * radius : radius)
				.shadow(radius: color == 2 ? 20 : 0)
				.opacity(color == 2 ? 1 : 0.3)
		}
		.padding()
		.overlay(
			RoundedRectangle(cornerRadius: 20)
				.stroke(Color.black, lineWidth: 5)
		)
		
	}
}

struct StoplightView_Previews: PreviewProvider {
	static var previews: some View {
		StoplightView(color: 0)
	}
}
