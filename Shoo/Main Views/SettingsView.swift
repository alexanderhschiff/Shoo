//
//  SettingsView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/21/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

enum editType {
    case name, houseName
}

struct SettingsView: View {
    
    @EnvironmentObject var fire: Fire
    @State private var name = "Name"
    @State private var houseName = "Home"
    @State private var reasons: [String] = []
    @State private var currentEdit: editType = .name
    
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
    }
    
    func move(from source: IndexSet, to destination: Int) {
        reasons.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        reasons.remove(atOffsets: offsets)
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
                                Text("Name")
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
                                        .onTapGesture {
                                            self.currentEdit = .name
                                    }
                                    
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
                            VStack(alignment: .leading, spacing: 5){
                                Text("House name")
                                ZStack{
                                    TextField(houseName, text: $houseName, onEditingChanged: { _ in
                                        self.color = Color.blue
                                    }, onCommit: {
                                        self.fire.setHouseName(self.houseName)
                                        self.color = Color.gray
                                    })
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding()
                                        .background(Color(UIColor.systemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        .onTapGesture {
                                            self.currentEdit = .houseName
                                    }
                                    
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            UIApplication.shared.endEditing() // Call to dismiss keyboard
                                            self.fire.setHouseName(self.houseName)
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
                            VStack(alignment: .leading, spacing: 5){
                                HStack{
                                    Text("Reasons")
                                    Spacer()
                                    EditButton()
                                }
                                List {
                                    ForEach(reasons, id: \.self) { reason in
                                        Text(reason)
                                    }
                                    .onMove(perform: move)
                                    .onDelete(perform: delete)
                                }
                                .cornerRadius(20)
                                .frame(height: UIScreen.main.bounds.height * 0.3)
                            }
                            
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            let url: NSURL = URL(string: "https://www.shoo.app/privacy_policy.html")! as NSURL
                            UIApplication.shared.open(url as URL)
                        }){
                            HStack{
                                Image(systemName: "link.circle.fill")
                                Text("Privacy policy")
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            let url: NSURL = URL(string: "https://www.shoo.app")! as NSURL
                            UIApplication.shared.open(url as URL)
                        }){
                            HStack{
                                Image(systemName: "link.circle.fill")
                                Text("App Website")
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .padding(.horizontal)
                        }
                        
                        Text("Made by Alexander and Benjamin Schiff")
                            .foregroundColor(.secondary)
                            .font(.headline)
                            .padding()
                            .frame(alignment: .center)
                    }
                }
                .onDisappear {
                    self.fire.saveCustomReasons(reasons: self.reasons)
                }
                    
                .onAppear{
                    self.name = self.fire.profile.name
                    self.reasons = self.fire.getCustomReasons()
                    self.houseName = self.fire.houseName
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(Fire())
    }
}
