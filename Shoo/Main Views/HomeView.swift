//
//  HomeView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

enum presentSheet{
	case editHouse, more, settings
}

struct HomeView: View {
	@EnvironmentObject var fire: Fire
	@State private var backgroundColor = Color.red
	@State private var showSheet = false
	@State private var sheetType: presentSheet = .editHouse
	
	var body: some View {
		GeometryReader { geo in
			ZStack{
				ScrollView(.vertical, showsIndicators: false){
					VStack(spacing: 0){
						Rectangle()
							.foregroundColor(Color.white.opacity(0))
							.frame(height: UIScreen.main.bounds.height * 0.15)
						ForEach(self.fire.mates) { mate in
							PersonView(name: mate.name, status: mate.status, reason: mate.reason, endTime: mate.end)
						}
						Rectangle()
							.foregroundColor(Color.white.opacity(0))
							.frame(height: UIScreen.main.bounds.height * 0.23)
					}
				}
				
				VStack(spacing: 0){
					TopView(topSafeArea: geo.safeAreaInsets.top, sheetType: self.$sheetType, showSheet: self.$showSheet).environmentObject(self.fire)
						.onAppear{
							print("LOOK HERE")
							dump(self.fire.mates)
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
		.background(Color(UIColor.secondarySystemBackground))
		.sheet(isPresented: self.$showSheet){
			if self.sheetType == .more{
				EditCardView().environmentObject(self.fire)
			}
			else if self.sheetType == .editHouse{
				EditHomeView().environmentObject(self.fire)
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
