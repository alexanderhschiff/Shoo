//
//  SettingsView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/21/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

//MARK: - Extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK: - EDIT TYPE
enum editType {
    case name, houseName
}

//MARK: - BUILD TEXT
func buildText() -> String {
    var ret = "Version: "
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        ret += version
    } else {
        ret += "unknown version"
    }
    if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        ret += " (\(build))"
    }
    return ret
}

struct SettingsView: View {
    
    @EnvironmentObject var fire: Fire
    @State private var name = "Name"
    @State private var houseName = "Home"
    @State private var reasons: [String] = []
    @State private var currentEdit: editType = .name
    
    @State private var showingAlert: Bool = false
    
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
    
    func leaveHouse() {
        showingAlert = true
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
                        buttonPressHaptic()
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
                            //MARK: - NAME
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
                            // MARK: - EDIT HOUSE
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
                            //MARK: - REASONS
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
                        
                        //MARK: LEAVE HOUSE
                        Button(action: {
                            buttonPressHaptic()
                            self.leaveHouse()
                        }){
                            HStack{
                                Spacer()
                            Text("Leave house")
                                .foregroundColor(.red)
                                Spacer()
                            }
                            
                        }
                        .padding(.horizontal)
                        .buttonStyle(WideButtonStyle(color: Color(UIColor.systemBackground)))
                        
                        // MARK: TECHNICAL BUTTONS
                        Button(action: {
                            buttonPressHaptic()
                            if let url = URL(string: "mailto:\(emailStr ?? "")") {
                                UIApplication.shared.open(url)
                            }
                        }){
                            HStack{
                                Image(systemName: "envelope.circle.fill")
                                Text("Email us")
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            buttonPressHaptic()
                            var components = URLComponents(url: appURL, resolvingAgainstBaseURL: false)
                            components?.queryItems = [
                                URLQueryItem(name: "action", value: "write-review")
                            ]
                            guard let writeReviewURL = components?.url else {
                                return
                            }
                            UIApplication.shared.open(writeReviewURL)
                        }){
                            HStack{
                                Image(systemName: "pencil.circle.fill")
                                Text("Write a review")
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            buttonPressHaptic()
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
                        
                        /* Commented out the "APP WEBSITE" Button
                         Button(action: {
                         buttonPressHaptic()
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
                         */
                        
                        Text("Made by Alexander and Benjamin Schiff")
                            .foregroundColor(.secondary)
                            .font(.headline)
                            .padding()
                            .frame(alignment: .center)
                        
                        Text(buildText())
                            .foregroundColor(.secondary)
                            .padding(.leading)
                            .frame(alignment: .center)
                    }
                }
                .onDisappear {
                    self.fire.saveCustomReasons(reasons: self.reasons)
                    self.fire.startListener()
                }
                    
                .onAppear{
                    self.name = self.fire.profile.name
                    self.reasons = self.fire.getCustomReasons()
                    self.houseName = self.fire.houseName
                }
            }
        }.alert(isPresented: $showingAlert){
            Alert(title: Text("Leaving house"), message: Text("Beta: please restart app for changes to be in effect"), primaryButton: .destructive(Text("Leave")) {
                let oldID = self.fire.profile.house
                self.fire.profile.house = self.fire.createHouse()
                print("leave: \(self.fire.profile.house) : \(oldID)")
                self.fire.updateHouse(self.fire.profile, oldID)
                self.fire.startListener()
                self.presentationMode.wrappedValue.dismiss()
            }, secondaryButton: .cancel())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(Fire())
    }
}
