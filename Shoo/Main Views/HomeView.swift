//
//  HomeView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

enum presentSheet{
    case editHouse, more
}

struct HomeView: View {
    @EnvironmentObject var fire: Fire
    @State private var backgroundColor = Color.red
    @State private var showSheet = false
    @State private var sheetType: presentSheet = .editHouse
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 0){
                        HStack{
                            Text("Home")
                                .fontWeight(.heavy)
                                .font(.largeTitle)
                            Spacer()
                            Image(systemName: "person.badge.plus.fill")
                                .font(.title)
                                .onTapGesture {
                                    self.sheetType = .editHouse
                                    self.showSheet = true
                            }
                        }
                        FreePeopleView(freePeople: self.fire.mates.count)
                            .font(.headline)
                    }
                    .padding([.horizontal, .top])
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack{
                            ForEach(self.fire.mates) { mate in
                                PersonView(name: mate.name, status: mate.status, reason: mate.reason, endTime: mate.end)
                            }
                            /*ForEach(0..<8){ mate in
                             PersonView(name: "Alexander", status: mate%3, reason: "👨‍💻 Working", endTime: Date().addingTimeInterval(TimeInterval(mate*1300)))
                             }*/
                        }
                        
                    }
                    
                }
            }.onAppear(perform: {
                self.fire.startListener()
            })
                .onDisappear(perform: {
                    self.fire.stopListener()
                })
            
            BottomView(more: self.$showSheet, eType: self.$sheetType)
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 120)
        }.sheet(isPresented: self.$showSheet){
            if(self.sheetType == .more){
                EditCardView()
            }
            else{
                EditHomeView().environmentObject(self.fire)
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
