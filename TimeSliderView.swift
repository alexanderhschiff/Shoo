//
//  TimeSliderView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/15/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct TimeSliderView: View {
	@Binding var time: Int
	
	let lit = Color.white.opacity(0.8)
	let dark = Color.gray.opacity(0.3)
	
	let num = 11
	
	var body: some View {
		GeometryReader{ geo in
			HStack(spacing: 2){
				ForEach(0..<11){ number in
					Rectangle()
						.frame(width: geo.size.width/CGFloat(self.num)-2, height: 50)
						.foregroundColor(number > self.time ? self.dark : self.lit)
						.onTapGesture {
							self.time = number
					}
				}
			}
			.mask(RoundedRectangle(cornerRadius: 20))
			.gesture(
				DragGesture()
					.onChanged{ gesture in
						let time = Int(gesture.location.x)/(Int(geo.size.width)/self.num)
						if time > 11{
							self.time = 11
						}
						else if time < 0{
							self.time = 0
						}
						else{
							self.time = time
						}
				}
			)
				.shadow(radius: 5, x: 1, y: 4)
		}
	}
}

struct TimeSliderView_Previews: PreviewProvider {
	static var previews: some View {
		TimeSliderView(time: .constant(4))
	}
}
