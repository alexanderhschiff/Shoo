//
//  LaunchScreenView.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject var fire: Fire
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        VStack(alignment: .leading){
                            Text("")
                                .fontWeight(.heavy)
                                .font(.largeTitle)
                                .lineLimit(1)
                            FreePeopleView().environmentObject(self.fire)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                        }){
                            ZStack(alignment: .center){
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .shadow(radius: 3, y: 3)
                                Image(systemName: "gear")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Button(action: {
                        }){
                            ZStack(alignment: .center){
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .shadow(radius: 3, y: 3)
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, (UIApplication.shared.windows.last?.safeAreaInsets.top)!)
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Blur(style: .systemMaterial))
                }
            }
            
            
            VStack(spacing: 0){
                Spacer()
                BottomView(more: .constant(false), eType: .constant(.more)).environmentObject(self.fire)
            }
            
        }
        .background(Color(UIColor.secondarySystemBackground))
        .edgesIgnoringSafeArea(.all)
        
    }
}


struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView().environmentObject(Fire())
    }
}
