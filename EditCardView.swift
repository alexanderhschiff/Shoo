//
//  EditCardView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI
import Foundation

struct EditCardView: View {
    @State private var tapped = false
    @State private var showingAlert = false
    @EnvironmentObject var fire: Fire
	
	//time variables
	@State private var time: Double = Date().timeIntervalSince1970
	@State private var selection: Int = 0
	
    @State private var defaultEnd: Double = Date().timeIntervalSince1970 //default end is now
	@State private var start: Double = Date().timeIntervalSince1970 //start is always now
    
    @State private var addReason = ""
    @State private var reasons = ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    @State private var newStatus: Int = 0
    @State private var newReason: String = ""
    
    @State private var custom = false
    @State private var customColor: Color = Color.gray
    
    func addReasonFunc() {
        let nR = addReason.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard nR.count > 0 else {
            addReason = ""
            return
        }
        
        if let i = reasons.firstIndex(of: nR) {
            self.reasons.remove(at: i)
            reasons.insert(nR, at: 0)
        } else {
            reasons.insert(nR, at: 0)
            self.fire.saveCustomReasons(reasons: reasons)
        }
        newReason = nR
        addReason = ""
        
    }
    
    var displayTime: String{
        switch selection{
        case 0:
            return "10 minutes"
        case 1:
            return "15 minutes"
        case 2:
            return "20 minutes"
        case 3:
            return "30 minutes"
        case 4:
            return "45 minutes"
        case 5:
            return "1 hour"
        case 6:
            return "2 hours"
        case 7:
            return "3 hours"
        case 8:
            return "4 hours"
        case 9:
            return "A while"
        case 10:
            return "All day"
        default:
            return "A while"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HandleView()
            
            Spacer()
            
			PersonView(name: fire.profile.name, status: newStatus, reason: newReason, endTime: time, startTime: start, id: fire.profile.uid, timerInterval: 5).environmentObject(fire)
            
            Spacer()
           
            VStack(alignment: .leading, spacing: 10){
                Text("Your status")
                    .font(.subheadline)
                
                HStack{
                    Button("Free"){
                        self.newStatus = 0
                    }
                    .buttonStyle(StatusButtonStyle(color: Color.green))
                    Button("Quiet"){
                        self.newStatus = 1
                    }
                    .buttonStyle(StatusButtonStyle(color: Color.yellow))
                    Button("Shoo"){
                        self.newStatus = 2
                    }
                    .buttonStyle(StatusButtonStyle(color: Color.red))
                    
                    Spacer()
                }
                .font(.headline)
                .foregroundColor(Color(UIColor.systemBackground))
            }
            .padding()
            
            VStack(alignment: .leading){
                Text("What's happening")
                    .font(.subheadline)
                    .padding(.leading)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(alignment: .center, spacing: 0){
                        ZStack{
                            TextField("+ Custom", text: $addReason, onEditingChanged: {_ in self.customColor = Color.blue }, onCommit: {
                                self.customColor = Color.gray
                                self.addReasonFunc()
                            })
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.headline)
                                .padding(16)
                                .padding(.trailing, 40)
                                .background(Color.gray.opacity(0.7))
                                .cornerRadius(20)
                                .shadow(radius: 3, y: 4)
                                .disableAutocorrection(true)
                                .padding([.leading, .bottom])
                            
                            HStack{
                                Spacer()
                                Button(action: {
                                    UIApplication.shared.endEditing() // Call to dismiss keyboard
                                    self.customColor = Color.gray
                                    self.addReasonFunc()
                                }){
                                    Image(systemName: "checkmark.circle")
                                        .padding([.trailing, .bottom])
                                        .font(.title)
                                        .foregroundColor(customColor)
                                }
                                .padding(.leading, 20)
                                
                            }
                        }
                        .fixedSize(horizontal: true, vertical: true)
                        .padding(.top, 5)
                        
                        ForEach(reasons, id: \.self){ reason in
                            Text(reason)
                                .reasonStyle(selected: reason == self.newReason)
                                .padding([.leading, .bottom])
                                .onTapGesture {
                                    self.newReason = reason
                            }
                            .padding(.top, 5)
                        }
                    }
                }
            }
            
            VStack(alignment: .leading){
                Text("For how long?")
                    .font(.subheadline)
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Image(systemName: "timer")
                        Text("\(self.displayTime)")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                    }
					TimeSliderView(time: self.$time, selection: self.$selection)
                        .frame(height: 60)
                        .padding([.top, .bottom, .trailing])
                        /*
                        .onTapGesture {
                            self.interval = self.intervalTime()
							self.start = Date().timeIntervalSince1970
                    }*/
                }
            }.padding(.leading)

                Button(action: {
                    self.showingAlert = true
                    self.tapped = true
                }){
                        if !self.tapped{
                            Text("Notify All")
                        } else{
                            Image(systemName: "checkmark.circle")
                        }
                    
                }
                .buttonStyle(WideButtonStyle(color: getColor(self.newStatus), tapped: tapped))
            
            Spacer()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .edgesIgnoringSafeArea(.bottom)
        .onDisappear {
			self.fire.saveState(user: self.fire.profile, status: self.newStatus, reason: self.newReason, end: self.time)
            self.fire.saveCustomReasons(reasons: self.reasons)
        }
        .onAppear {
            self.newReason = self.fire.profile.reason
            self.newStatus = self.fire.profile.status
            self.reasons = self.fire.getCustomReasons()
            self.defaultEnd = self.fire.profile.end
			self.time = self.fire.profile.end
			self.start = self.fire.profile.start
        }
        .alert(isPresented: $showingAlert){
            Alert(title: Text("Feature coming soon..."))
        }
    }
}


struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView().environmentObject(Fire())
    }
}
