//
//  ContentView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject var spark: Spark
    var body: some View {
        ZStack {
            if spark.isUserAuthenticated == .undefined {
                LaunchScreenView()
            } else if spark.isUserAuthenticated == .signedOut {
                SignInView()
            } else if spark.isUserAuthenticated == .signedIn {
                HomeView().environmentObject(HouseData(userID: self.spark.profile.uid))
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
