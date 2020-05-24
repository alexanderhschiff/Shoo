//
//  LaunchScreenView.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI

struct LaunchScreenView: View {
	@EnvironmentObject var fire: Fire
	
	var body: some View {
		GeometryReader { geo in
			ZStack{
				VStack(alignment: .leading){
					VStack(alignment: .leading, spacing: 0){
						HStack{
							Text("Home")
								.fontWeight(.heavy)
								.font(.largeTitle)
							Spacer()
							Image(systemName: "person.badge.plus.fill")
								.font(.title)
						}
						Text("")
							.font(.headline)
					}
					.padding(.horizontal)
					.padding(.top, geo.safeAreaInsets.top)
					.background(Blur(style: .systemChromeMaterial))
					//.edgesIgnoringSafeArea(.top)
					
					
					Spacer()
				}
				
				
				VStack(spacing: 0){
					Spacer()
					BottomView(more: .constant(false), eType: .constant(.more)).environmentObject(self.fire)
				}
				
			}
			.background(Color(UIColor.secondarySystemBackground))
			.edgesIgnoringSafeArea(.all)
			
		}
	}
}

struct LaunchScreenView_Previews: PreviewProvider {
	static var previews: some View {
		LaunchScreenView().environmentObject(Fire())
	}
}
