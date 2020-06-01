//
//  HomeTitleView.swift
//  Shoo
//
//  Created by Alexander Schiff on 6/1/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct HomeTitleView: View {
	@EnvironmentObject var fire: Fire
	
	@Binding var sheetType: presentSheet
	@Binding var showSheet: Bool
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0){
			FreePeopleView().environmentObject(self.fire)
			.font(.system(size: 20, weight: .semibold))
			.foregroundColor(.secondary)
			.lineLimit(1)
			
			HStack{
				Button(action: {
					buttonPressHaptic()
					self.sheetType = .settings
					self.showSheet = true
				}){
					HStack{
						Text(self.fire.houseName)
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
					buttonPressHaptic()
					self.sheetType = .editHouse
					self.showSheet = true
				}){
					Image(systemName: "person.crop.circle.fill.badge.plus")
						.font(.system(size: 30))
						.foregroundColor(.primary)
				}
			}
		}
		.padding(.horizontal)
	}
}

struct HomeTitleView_Previews: PreviewProvider {
	static var previews: some View {
		HomeTitleView(sheetType: .constant(.editHouse), showSheet: .constant(false)).environmentObject(Fire())
	}
}