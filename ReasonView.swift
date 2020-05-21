//
//  ReasonView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct Reason: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(20)
            .shadow(radius: 3, y: 2)
    }
}

extension View{
    func reasonStyle() -> some View{
        self.modifier(Reason())
        
    }
}
