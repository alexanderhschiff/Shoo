//
//  AddNameView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/31/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct AddNameView: View {
	
	@EnvironmentObject var fire: Fire
	@State private var name = ""
	
	@Environment(\.presentationMode) var presentationMode
	
	init() {
		UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
	}
	
	@State private var color: Color = Color.gray
	@State private var isEditing = true
	
	@State private var alert = false
	
	var body: some View {
		ZStack{
			Color(UIColor.secondarySystemBackground)
				.edgesIgnoringSafeArea(.all)
			
			
			VStack(alignment: .leading){
				HStack{
					Text("Add name")
						.font(.largeTitle)
						.fontWeight(.bold)
					Spacer()
					Button(action: {
						if !self.name.isEmpty {
							UIApplication.shared.endEditing() // Call to dismiss keyboard
							self.fire.changeName(self.name)
							buttonPressHaptic()
							self.presentationMode.wrappedValue.dismiss()
						} else{
							self.color = Color.gray
							self.alert = true
						}
					}){
						Text("Next".uppercased())
							.font(.headline)
							.fontWeight(.semibold)
							.foregroundColor(color)
					}
					.padding(8)
					.background(Color(UIColor.systemBackground))
					.clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
				}
				.padding()
				
				VStack(alignment: .leading){
					Text("Please add your name")
						.font(.headline)
						
					ZStack{
						TextField(name, text: $name, onEditingChanged: { _ in
							self.color = Color.blue
						}, onCommit: {
							if !self.name.isEmpty {
								self.fire.changeName(self.name)
								self.presentationMode.wrappedValue.dismiss()
							} else{
								self.color = Color.gray
								self.alert = true
							}
						})
							.textFieldStyle(PlainTextFieldStyle())
							.padding()
							.background(Color(UIColor.systemBackground))
							.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
						
						HStack{
							Spacer()
							Button(action: {
								if !self.name.isEmpty {
									UIApplication.shared.endEditing() // Call to dismiss keyboard
									self.fire.changeName(self.name)
									buttonPressHaptic()
									self.presentationMode.wrappedValue.dismiss()
								} else{
									self.color = Color.gray
									self.alert = true
								}
							}){
								Image(systemName: "checkmark.circle")
									.padding(.trailing)
									.font(.title)
									.foregroundColor(color)
							}
						}
					}
					Spacer()
				}
				.alert(isPresented: $alert){
					Alert(title: Text("Enter name"), message: Text("Others need to know who you are! You can edit this name later."), dismissButton: .cancel(Text("OK")))
				}
				.padding()
				.onAppear{
					self.name = self.fire.profile.name
				}
			}
		}
		.highPriorityGesture(DragGesture())
	}
}

struct AddNameView_Previews: PreviewProvider {
	static var previews: some View {
		AddNameView().environmentObject(Fire())
	}
}
