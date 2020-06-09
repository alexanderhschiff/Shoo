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
		ZStack{
			VStack(alignment: .leading, spacing: 0){
				Text("Loading")
				.font(.system(size: 20, weight: .semibold))
				.foregroundColor(.secondary)
				.lineLimit(1)
				
				HStack{
					Button(action: {
						//none
					}){
						HStack{
							Text("Home")
								.font(.system(size: 30, weight: .bold))
								.lineLimit(1)
								.foregroundColor(.primary)
							Image(systemName: "chevron.right")
								.font(.system(size: 20))
								.foregroundColor(.primary)
						}
					}
					
					Spacer()
					
					Button(action: {
						//none
					}){
						Image(systemName: "person.crop.circle.fill.badge.plus")
							.font(.system(size: 30))
							.foregroundColor(.primary)
					}
				}
                Spacer()
			}
			.padding(.horizontal)
            
            VStack(spacing: 0){
                Spacer()
                BottomView(more: .constant(false), eType: .constant(.more)).environmentObject(self.fire)
            }
            
        }
        .background(Color(UIColor.secondarySystemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}


struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView().environmentObject(Fire())
    }
}
