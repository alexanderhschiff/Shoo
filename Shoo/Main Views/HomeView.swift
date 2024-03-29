//
//  HomeView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

enum presentSheet{
    case editHouse, more, settings, addName
}

struct HomeView: View {
    @EnvironmentObject var fire: Fire
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @State private var backgroundColor = Color.red
    @State private var showSheet = false
    @State private var sheetType: presentSheet = .editHouse
    @State var currentTime = Date()
    
    @State private var posY: CGFloat = 0
    
    let safeArea = (UIApplication.shared.windows.last?.safeAreaInsets.top)!
    
    var body: some View {
        ZStack{
            //MARK: -NOTIFICATION
            VStack {
                HStack{
                    Image(systemName: "bell.fill")
                        .foregroundColor(.yellow)
                        .rotationEffect(.degrees(fire.isShowingNotification ? -15 : 20))
                        .animation(Animation.interpolatingSpring(stiffness: 150, damping: 2).repeatForever(autoreverses: false))
                        .font(.system(size: 20, weight: .light))
                    Text("Reminder sent")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .shadow(radius: 6, x: 0, y: 3)
                .offset(y: fire.isShowingNotification ? (UIApplication.shared.windows.last?.safeAreaInsets.top)! : -80)
                .animation(.spring())
                Spacer()
            }.zIndex(10)
                .accessibility(label: Text("Reminder sent."))
            
            // MARK: - HOME VIEW
            ZStack{
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment: .leading, spacing: 0){
                        GeometryReader { geo -> Text in
                            self.posY = geo.frame(in: .global).minY
                            return Text("") //need to return a view
                        }
                        HomeTitleView(sheetType: self.$sheetType, showSheet: self.$showSheet).environmentObject(self.fire)
                        if self.fire.mates.count > 0 {
                            ForEach(self.fire.mates) { mate in
                                PersonView(mate: mate)
                                    .environmentObject(self.fire)
                                    .shadow(radius: 6, x: 0, y: 3)
                            }
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 0.3 * UIScreen.main.bounds.height)
                            
                            //no mates
                        } else{
                            VStack{
                                //two top buttons
                                HStack{
                                    VStack(alignment: .leading){
                                        Image(systemName: "arrow.up")
                                        Text("Group settings")
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Image(systemName: "arrow.up")
                                        Text("Add people to your group")
                                    }
                                }
                                Spacer()
                                //bottom buttom
                                VStack{
                                    Text("Change your status with quick controls, or tap to expand. You can also remind everyone of your status if they forget!")
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Image(systemName: "arrow.down")
                                }
                            }
                            .frame(minHeight: UIScreen.main.bounds.height - 0.4 * UIScreen.main.bounds.height)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.secondary)
                            .padding()
                        }
                    }
                }
            }
            .padding(.top, safeArea)
            
            
            /*
             VStack(spacing: 0){
             TopView(sheetType: self.$sheetType, showSheet: self.$showSheet).environmentObject(self.fire)
             Spacer()
             }*/
            
            //top safe area blur
            VStack(spacing: 0){
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: (UIApplication.shared.windows.last?.safeAreaInsets.top)!)
                    .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(self.reduceTransparency ? 1 : Double(100 + (posY - safeArea))/100))
                    .background(Blur(style: .systemUltraThinMaterial))
                    .background(self.reduceTransparency ? Color(UIColor.secondarySystemBackground) : Color.clear)
                Spacer()
            }
            
            VStack(spacing: 0){
                Spacer()
                BottomView(more: self.$showSheet, eType: self.$sheetType).environmentObject(self.fire)
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            self.fire.startListener()
            if self.fire.profile.name == "" {
                self.sheetType = .addName
                self.showSheet = true
            }
        })
            .onDisappear(perform: {
                self.fire.stopListener()
            })
            .sheet(isPresented: self.$showSheet){
                if self.sheetType == .more{
                    EditCardView().environmentObject(self.fire)
                }
                else if self.sheetType == .editHouse{
                    EditHomeView().environmentObject(self.fire)
                } else if self.sheetType == .addName {
                    AddNameView().environmentObject(self.fire)
                } else {
                    SettingsView().environmentObject(self.fire)
                }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Fire())
    }
}
