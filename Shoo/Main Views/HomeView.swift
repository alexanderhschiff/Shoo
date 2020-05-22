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
    @State var currentTime = Date()
    //updates every 15 seconds - can update later
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    
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
                                
                                Button(action: {
                                    self.sheetType = .editHouse
                                    self.showSheet = true
                                }){
                                    ZStack(alignment: .center){
                                        Circle()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color(UIColor.systemBackground))
                                            .shadow(radius: 3, y: 3)
                                        Image(systemName: "person.badge.plus.fill")
                                            .renderingMode(.original)
                                    }
                                }
                            }
                            FreePeopleView(freePeople: self.fire.mates.count)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding([.horizontal, .bottom])
                        .padding(.top, geo.safeAreaInsets.top)
                        .frame(width: UIScreen.main.bounds.width)
                        .background(Blur(style: .systemChromeMaterial))
                        
                    }
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing: 0){
                            ForEach(self.fire.mates) { mate in
                                PersonView(currentTime: self.currentTime, name: mate.name, status: mate.status, reason: mate.reason, endTime: mate.end, startTime: mate.start)
                            }
                            //rectangle just adds stuff to go under z stack when you scroll down
                            Rectangle()
                                .foregroundColor(Color.white.opacity(0))
                                .frame(height: UIScreen.main.bounds.height * 0.23)
                        }
                        
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 0){
                    Spacer()
                    BottomView(bottomSafeArea: geo.safeAreaInsets.bottom, more: self.$showSheet, eType: self.$sheetType).environmentObject(self.fire)
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
        .onReceive(timer){ input in
            self.currentTime = input
        }
        .background(Color(UIColor.secondarySystemBackground))
        .sheet(isPresented: self.$showSheet){
            if(self.sheetType == .more){
                EditCardView().environmentObject(self.fire)
            }
            else{
                EditHomeView().environmentObject(self.fire)
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Fire())
    }
}
