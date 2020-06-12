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
    
    var date: String{
    let now = Date()
    let formatter = DateFormatter()

    //weekday
    formatter.dateFormat = "EEEE"
    let weekday = formatter.string(from: now)

    //month
    formatter.dateFormat = "LLLL"
    let month = formatter.string(from: now)

    //day
    let day = Calendar.current.dateComponents([.day], from: now).day
    return "\(weekday), \(month) \(day!)"
    }
	
	@Binding var sheetType: presentSheet
	@Binding var showSheet: Bool
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0){
			//FreePeopleView().environmentObject(self.fire)
            Text(date.uppercased())
			.font(.system(size: 12, weight: .semibold))
			.foregroundColor(.secondary)
			.lineLimit(1)
			
			HStack{
				Button(action: {
                    buttonPressHaptic(self.fire.reduceHaptics)
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
                    buttonPressHaptic(self.fire.reduceHaptics)
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
