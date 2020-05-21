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
                VStack(alignment: .leading, spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
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
                        .padding([.horizontal, .bottom])
                        .padding(.top, geo.safeAreaInsets.top)
                        .frame(width: UIScreen.main.bounds.width)
                        .background(Blur(style: .systemChromeMaterial))
                        
                    }
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack{
                            ForEach(self.fire.mates) { mate in
                                PersonView(name: mate.name, status: mate.status, reason: mate.reason, endTime: mate.end)
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 0){
                    Spacer()
                    BottomView(bottomSafeArea: geo.safeAreaInsets.bottom, more: self.$showSheet, eType: self.$sheetType)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                self.fire.startListener()
            })
                .onDisappear(perform: {
                    self.fire.stopListener()
                })
        }
        .sheet(isPresented: self.$showSheet){
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
