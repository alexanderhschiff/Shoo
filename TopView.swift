//
//  TopView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/21/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct TopView: View {
	
	let topSafeArea: CGFloat
	@EnvironmentObject var fire: Fire
	
	@Binding var sheetType: presentSheet
	@Binding var showSheet: Bool

	var freePeople: Int{
		/*var ret: Int = 0
		ForEach(fire.mates){ mate in
			if mate.status == 0 {
				ret += 1
			}
		}*/
		return self.fire.mates.count
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0){
			HStack{
				VStack(alignment: .leading){
					Text("Home")
						.fontWeight(.heavy)
						.font(.largeTitle)
					FreePeopleView().environmentObject(self.fire)
				}
				
				Spacer()
				
				Button(action: {
					self.sheetType = .settings
					self.showSheet = true
				}){
					ZStack(alignment: .center){
						Circle()
							.frame(width: 50, height: 50)
							.foregroundColor(Color(UIColor.systemBackground))
							.shadow(radius: 3, y: 3)
						Image(systemName: "gear")
							.font(.headline)
							.foregroundColor(.primary)
					}
				}
				
				Button(action: {
					self.sheetType = .editHouse
					self.showSheet = true
				}){
					ZStack(alignment: .center){
						Circle()
							.frame(width: 50, height: 50)
							.foregroundColor(Color(UIColor.systemBackground))
							.shadow(radius: 3, y: 3)
						Image(systemName: "person.badge.plus.fill")
							.font(.headline)
							.foregroundColor(.primary)
					}
				}
			}
			.padding([.horizontal, .bottom])
			.padding(.top, topSafeArea)
			.frame(width: UIScreen.main.bounds.width)
			.background(Blur(style: .systemMaterial))
		}
	}
}

struct TopView_Previews: PreviewProvider {
	static var previews: some View {
		Text("Hi")
		//TopView(topSafeArea: 20, sheetType: .constant(.more), showSheet: .constant(true)).en
	}
}
