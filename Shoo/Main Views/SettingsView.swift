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

struct SettingsView: View {
    
    @EnvironmentObject var fire: Fire
    @State private var name = "Name"
    @State private var reasons: [String] = []
    
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
                
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 5){
                        Text("Edit name")
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
                    }
                    
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    let url: NSURL = URL(string: "https://www.apple.com")! as NSURL
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
                    let url: NSURL = URL(string: "https://www.apple.com")! as NSURL
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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(Fire())
    }
}
