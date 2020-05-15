//
//  HappeningView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct HappeningView: View {
	var body: some View {
		HStack{
			Text("🤳")
			Text("Phone time")
		}
		.padding()
		.frame(width: 100, height: 30)
		.cornerRadius(20)
	}
}

struct HappeningView_Previews: PreviewProvider {
	static var previews: some View {
		HappeningView()
	}
}
