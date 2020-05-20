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
            .padding()    }
}

extension View{
    func reasonStyle() -> some View{
        ZStack(alignment: .leading){
            Color.gray
                .opacity(0.3)
                .blur(radius: 1)
            self.modifier(Reason())
        }
        .frame(width: 250, height: 50)
        .cornerRadius(20)
        .shadow(radius: 5, y: 5)
    }
}
