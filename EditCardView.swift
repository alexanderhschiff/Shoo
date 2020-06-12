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
    @EnvironmentObject var fire: Fire
    
    @Environment(\.presentationMode) var presentationMode
    
    //time variables
    @State private var time: Double = Date().timeIntervalSince1970
    //@State private var selection: Int = 0
    
    @State private var defaultEnd: Double = Date().timeIntervalSince1970 //default end is now
    @State private var start: Double = Date().timeIntervalSince1970 //start is always now
    
    @State private var addReason = ""
    @State private var reasons = ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    @State private var newStatus: Status = .green
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
        switch self.fire.timeSelection{
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
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        VStack(alignment: .leading){
            HandleView()
            
            Spacer()
            // MARK: - Person View
            PersonView(id: self.fire.profile.uid, name: self.fire.profile.name, reason: self.newReason, status: self.newStatus, end: self.time, start: self.start, pushToken: self.fire.profile.pushToken).environmentObject(fire)
                .shadow(radius: 3, y: 1)
                .highPriorityGesture(TapGesture()) //to override tap expansion
            
            Spacer()
            // MARK: - Statuses
            VStack(alignment: .leading, spacing: 10){
                Text("Your status")
                    .font(.headline)
                
                HStack{
                    Button("Free"){
                        self.newStatus = .green
                        buttonPressHaptic(self.fire.reduceHaptics)
                    }
                    .buttonStyle(StatusButtonStyle(color: Color.green, selected: newStatus == .green))
                    Button("Quiet"){
                        self.newStatus = .yellow
                        buttonPressHaptic(self.fire.reduceHaptics)
                    }
                    .buttonStyle(StatusButtonStyle(color: Color.yellow, selected: newStatus == .yellow))
                    Button("Shoo"){
                        self.newStatus = .red
                        buttonPressHaptic(self.fire.reduceHaptics)
                    }
                    .buttonStyle(StatusButtonStyle(color: Color.red, selected: newStatus == .red))
                    
                    Spacer()
                }
                .font(.headline)
                .foregroundColor(Color(UIColor.systemBackground))
            }
            .padding()
            // MARK: - REASONS
            VStack(alignment: .leading){
                Text("What's happening")
                    .font(.headline)
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
                                .padding(14)
                                .padding(.trailing, 40)
                                .background(Color.gray.opacity(0.4))
                                //.overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.blue, lineWidth: 2))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                //.shadow(radius: 2, y: 2)
                                .disableAutocorrection(false)
                                .padding([.leading, .bottom])
                            
                            HStack{
                                Spacer()
                                Button(action: {
                                    buttonPressHaptic(self.fire.reduceHaptics)
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
                                    buttonPressHaptic(self.fire.reduceHaptics)
                                    self.newReason = reason
                            }
                            .padding(.top, 5)
                        }
                        
                        Rectangle()
                            .frame(width: 14, height: 1)
                            .opacity(0)
                    }
                }
            }
            // MARK: - TIME SLIDER
            VStack(alignment: .leading){
                Text("For how long?")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Image(systemName: "timer")
                        Text("\(self.displayTime)")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    TimeSliderView(time: self.$time)
                        .frame(height: 60)
                        .padding([.top, .bottom, .trailing])
                }
            }.padding(.leading)
            
            //MARK: - UPDATE BUTTONS
            HStack{
                Button(action: {
                    buttonPressHaptic(self.fire.reduceHaptics)
                    self.fire.saveState(user: self.fire.profile, status: self.newStatus, reason: self.newReason, end: self.time)
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Update")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .padding(.horizontal)
                }
                .buttonStyle(WideButtonStyle(color: Color.gray.opacity(0.4)))
                
                Spacer()
                
                Button(action: {
                    buttonPressHaptic(self.fire.reduceHaptics)
                    self.fire.saveState(user: self.fire.profile, status: self.newStatus, reason: self.newReason, end: self.time)
                    self.fire.remindHouse()
                    self.presentationMode.wrappedValue.dismiss()
                    /*
                    withAnimation(.linear(duration: 0.3)){
                        self.tapped = true
                    }
                    //dismiss edit card view after pressing update, but with time to see checkmark animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentationMode.wrappedValue.dismiss()
                    }*/
                }){
                    if !self.tapped{
                        Text("Update & Notify All")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .padding(.horizontal)
                        
                    } else{
                        HStack{
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                            Spacer()
                        }
                        .transition(.opacity)
                    }
                }
                .buttonStyle(WideButtonStyle(color: getColor(status: self.newStatus)))
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .edgesIgnoringSafeArea(.bottom)
        .onDisappear {
            //Want to not save their status if they dismiss, only save if they press
            //self.fire.saveState(user: self.fire.profile, status: self.newStatus, reason: self.newReason, end: self.time)
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
        .offset(y: -0.3 * keyboard.currentHeight)
    }
    
}


struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView().environmentObject(Fire())
    }
}
