//
//  ContentView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct Reason: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()	}
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

struct ContentView: View {
    
    @EnvironmentObject var spark: Spark
    var body: some View {
        ZStack {
            if spark.isUserAuthenticated == .undefined {
                LaunchScreenView()
            } else if spark.isUserAuthenticated == .signedOut {
                SignInView()
            } else if spark.isUserAuthenticated == .signedIn {
                HomeView()
            }
        }.onAppear{
            self.spark.configureFirebaseStateDidChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
