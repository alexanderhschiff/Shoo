//
//  CircleStatusView.swift
//  ShooWidget
//
//  Created by Benjamin Schiff on 5/27/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct CircleStatusView: View {
    let radius: CGFloat
    let status: Int
    let initial: String
    
    var color: Color {
        switch status {
        case 1:
            return Color.green
        case 2:
            return Color.yellow
        case 3:
            return Color.red
        default:
            return Color.gray
        }
    }
    
    var body: some View {
        Circle()
        .foregroundColor(color)
        .frame(width: self.radius, height: self.radius, alignment: .center)
        .overlay(
            Text(initial)
            .font(.largeTitle)
        )
        
    }
}
