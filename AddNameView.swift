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
    
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            
            
            
            VStack(alignment: .leading){
                HandleView()
                
                HStack{
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Done".uppercased())
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .padding(8)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .padding(.horizontal)
                
                ScrollView(.vertical){
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            VStack(alignment: .leading, spacing: 5){
                                Text("Please add your name")
                                    .font(.largeTitle)
                                ZStack{
                                    TextField(name, text: $name, onEditingChanged: { _ in
                                        self.color = Color.blue
                                    }, onCommit: {
                                        self.fire.changeName(self.name)
                                        self.color = Color.gray
                                    })
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding()
                                        .background(Color(UIColor.systemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            UIApplication.shared.endEditing() // Call to dismiss keyboard
                                            self.fire.changeName(self.name)
                                            self.color = Color.gray
                                        }){
                                            Image(systemName: "checkmark.circle")
                                                .padding(.trailing)
                                                .font(.title)
                                                .foregroundColor(color)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onAppear{
                        self.name = self.fire.profile.name
                    }
                }
            }
        }
    }
}

struct AddNameView_Previews: PreviewProvider {
    static var previews: some View {
        AddNameView().environmentObject(Fire())
    }
}
