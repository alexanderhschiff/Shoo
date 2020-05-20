//
//  LaunchScreenView.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI

let blueGradient = Gradient(colors: [ColorPalette.blue1, ColorPalette.blue2])

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
        LinearGradient(gradient: blueGradient,startPoint: .topLeading, endPoint: .bottomTrailing)
        Text("Loading...")
            .foregroundColor(.yellow)
            .font(.largeTitle)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

import UIKit

enum ColorPalette {

    static let blue1 =  Color(UIColor(red:0.067, green: 0.337, blue: 1.000, alpha: 1.000))

    static let blue2 =  Color(UIColor(red:0.000, green: 0.047, blue: 0.710, alpha: 1.000))
}
