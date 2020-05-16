//
//  LeveledTimeSliderView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/16/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct LeveledTimeSliderView: View {
    var body: some View {
		HStack(alignment: .bottom, spacing: 20){
			ForEach(0..<11){
				RoundedRectangle(cornerRadius: 10)
					.frame(width: 10, height: CGFloat(pow(Float($0+3), 2.0)))
			}
		}
    }
}

struct LeveledTimeSliderView_Previews: PreviewProvider {
    static var previews: some View {
        LeveledTimeSliderView()
    }
}
