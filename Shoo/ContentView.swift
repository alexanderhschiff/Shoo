//
//  ContentView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var backgroundColor = Color.red
	var body: some View {
		GeometryReader { geo in
			ZStack{
				Color(UIColor(red:0.95, green: 0.95, blue: 0.95, alpha: 1))
				ScrollView(.vertical){
					VStack{
						ForEach(0..<10){ status in
							MemberView(name: "Alex", status: status%3, reason: "Watching TV")
								.padding(.horizontal)
								.padding(.top, 15)
						}
					}
				}
				MemberView(name: "Benjamin", status: 2, reason: "Main User")
					.padding()
					.position(x: geo.size.width/2, y: geo.size.height-100)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
