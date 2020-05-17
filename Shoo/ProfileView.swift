//
//  ProfileView.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Spacer()
            }.navigationBarTitle("Hi!")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
