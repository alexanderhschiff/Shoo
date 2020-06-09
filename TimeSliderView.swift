//
//  TimeSliderView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/15/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct TimeSliderView: View {
	@EnvironmentObject var fire: Fire
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
	@Binding var time: Double
	//@Binding var selection: Int
	
	func intervalTime() -> Double{
		switch self.fire.timeSelection{
		case 0:
			return Date().timeIntervalSince1970 + 10*60 //10 minutes
		case 1:
			return Date().timeIntervalSince1970 + 15*60 //15 minutes
		case 2:
			return Date().timeIntervalSince1970 + 20*60 //20 minutes
		case 3:
			return Date().timeIntervalSince1970 + 30*60 //30 minutes
		case 4:
			return Date().timeIntervalSince1970 + 45*60 //45 minutes
		case 5:
			return Date().timeIntervalSince1970 + 60*60//1 hour
		case 6:
			return Date().timeIntervalSince1970 + 120*60 //2 hours
		case 7:
			return Date().timeIntervalSince1970 + 180*60 //3 hours
		case 8:
			return Date().timeIntervalSince1970 + 240*60 //4 hours
		case 9:
			return Date().timeIntervalSince1970 + 360*60 //6 hours (a while)
		case 10:
            return Date.distantFuture.timeIntervalSince1970
		default:
			return 0
		}
	}
	
	var body: some View {
		GeometryReader{ geo in
			HStack(spacing: 2){
				ForEach(0..<11){ number in
					Rectangle()
						.foregroundColor(number > self.fire.timeSelection ? Color.gray.opacity(0.4) : Color.white)
						.frame(width: geo.size.width/CGFloat(11)-2, height: 50)
						.onTapGesture {
                            self.selectionFeedbackGenerator.selectionChanged()
							self.fire.timeSelection = number
							self.time = self.intervalTime()
					}
				}
			}
			.highPriorityGesture(
				DragGesture()
					.onChanged{ gesture in
						let newSelection = Int(gesture.location.x)/(Int(UIScreen.main.bounds.width)/11)
						if newSelection > 10{
							self.fire.timeSelection = 10
						}
						else if newSelection < 0{
							self.fire.timeSelection = 0
						}
						else{
							if (newSelection != self.fire.timeSelection){
								self.selectionFeedbackGenerator.selectionChanged()
                            }
							self.fire.timeSelection = newSelection
						}
						self.time = self.intervalTime()
				}
			)
			.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
			.frame(width: geo.size.width)
			.shadow(radius: 3)
		}
	}
}

struct TimeSliderView_Previews: PreviewProvider {
	static var previews: some View {
		TimeSliderView(time: .constant(9)).environmentObject(Fire())
	}
}
