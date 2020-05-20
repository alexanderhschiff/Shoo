//
//  ProgressView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/18/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct ProgressView: View {
	
	var progress: Float
	var width: Float
	
	var body: some View {
		ZStack{
			Circle()
				.stroke(lineWidth: CGFloat(self.width))
				.opacity(0.3)
			
			Circle()
				.trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
				.stroke(style: StrokeStyle(lineWidth: CGFloat(self.width), lineCap: .round, lineJoin: .round))
				.rotationEffect(Angle(degrees: -90.0))
				.animation(.linear)
		}
	}
}

struct ProgressView_Previews: PreviewProvider {
	static var previews: some View {
		ProgressView(progress: 0.65, width: 10.0)
	}
}
