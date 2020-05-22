//
//  ReasonView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct Reason: ViewModifier {
	
	let selected: Bool
	
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()
			.background(selected == true ? Color(UIColor.systemBackground): Color.gray.opacity(0.7))
            .cornerRadius(20)
            .shadow(radius: 3, y: 2)
			.lineLimit(1)
			.fixedSize(horizontal: false, vertical: true)
    }
}

extension View{
	func reasonStyle(selected: Bool) -> some View{
        self.modifier(Reason(selected: selected))
    }
}
