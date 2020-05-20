//
//  ContentView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject var fire: Fire
    var body: some View {
        ZStack {
            if fire.isUserAuthenticated == .undefined {
                LaunchScreenView()
            } else if fire.isUserAuthenticated == .signedOut {
                SignInView()
            } else if fire.isUserAuthenticated == .signedIn {
                if(fire.profile.uid == ""){
                    LaunchScreenView()
                }else{
                    HomeView().environmentObject(fire)
                }
            }
        }.onAppear{
            self.fire.configureFirebaseStateDidChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
