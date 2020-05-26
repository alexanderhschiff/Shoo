//
//  TopView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/21/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct TopView: View {
    
    @EnvironmentObject var fire: Fire
    
    @Binding var sheetType: presentSheet
    @Binding var showSheet: Bool
    
    var freePeople: Int{
        /*var ret: Int = 0
         ForEach(fire.mates){ mate in
         if mate.status == 0 {
         ret += 1
         }
         }*/
        return self.fire.mates.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack{
                VStack(alignment: .leading){
                    Text(self.fire.houseName)
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                        .lineLimit(1)
                    FreePeopleView().environmentObject(self.fire)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button(action: {
                    buttonPressHaptic()
                    self.sheetType = .settings
                    self.showSheet = true
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
                    buttonPressHaptic()
                    self.sheetType = .editHouse
                    self.showSheet = true
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
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(sheetType: .constant(.editHouse), showSheet: .constant(false)).environmentObject(Fire())
    }
}
