//
//  TopView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/21/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct TopView: View {
	
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
			HStack(alignment: .center){
				VStack(alignment: .leading, spacing: 0){
					Button(action: {
						buttonPressHaptic()
						self.sheetType = .settings
						self.showSheet = true
					}){
						HStack{
							Text(self.fire.houseName)
								.fontWeight(.heavy)
								.font(.system(size: 30))
								.lineLimit(1)
								.foregroundColor(.primary)
							Image(systemName: "chevron.right")
								.font(.system(size: 20))
								.foregroundColor(.primary)
						}
					}
					
					FreePeopleView().environmentObject(self.fire)
						.font(.system(size: 20, weight: .semibold))
						.foregroundColor(.secondary)
						.lineLimit(1)
				}
				
				Spacer()
				
				Button(action: {
					buttonPressHaptic()
					self.sheetType = .editHouse
					self.showSheet = true
				}){
					Image(systemName: "person.badge.plus.fill")
						.font(.system(size: 30))
						.foregroundColor(.primary)
				}
			}
			.padding([.horizontal, .bottom])
			.padding(.top, (UIApplication.shared.windows.last?.safeAreaInsets.top)!)
			.frame(width: UIScreen.main.bounds.width)
			.background(Blur(style: .systemMaterial))
		}
	}
}

struct TopView_Previews: PreviewProvider {
	static var previews: some View {
		TopView(sheetType: .constant(.editHouse), showSheet: .constant(false)).environmentObject(Fire())
	}
}
