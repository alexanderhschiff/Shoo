//
//  EditCardView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI
import Foundation

struct WideButton: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding()
            .foregroundColor(Color(UIColor.systemBackground))
    }
}

extension View{
    func wideButtonStyle(color: Color) -> some View{
        self.modifier(WideButton(color: color))
    }
}

struct StatusButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(color)
            .foregroundColor(Color(UIColor.systemBackground))
            .fixedSize(horizontal: true, vertical: false)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(radius: 3, y: 2)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}



struct EditCardView: View {
    @EnvironmentObject var fire: Fire
    @State private var time: Int = 10
    
    @State private var addReason = ""
    @State private var reasons = ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    @State private var newStatus: Int = 0
    @State private var newReason: String = ""
    
    @State private var custom = false
    
    func addReasonFunc() {
        let nR = addReason.trimmingCharacters(in: .whitespacesAndNewlines)
        dump(nR)
        guard nR.count > 0 else {
            addReason = ""
            return
        }
        
        reasons.insert(nR, at: 0)
        newReason = nR
        addReason = ""
        self.fire.saveCustomReasons(reasons: reasons)
    }
    
    var displayTime: String{
        switch time{
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
    
    @State private var customColor: Color = Color.gray
    
    var body: some View {
        VStack(alignment: .leading){
            HandleView()
            
            Spacer()
            
            PersonView(currentTime: self.currentTime, name: fire.profile.name, status: newStatus, reason: newReason, endTime: newEnd(), startTime: fire.profile.start)
            
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
                                .padding(14)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(20)
                                .shadow(radius: 3, y: 2)
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
                            }
                        }
                        /*
                         else {
                         Text("+ Custom")
                         .reasonStyle()
                         .padding([.leading, .bottom])
                         .onTapGesture {
                         self.custom = true
                         }
                         }*/
                        ForEach(reasons, id: \.self){ reason in
                            Text(reason)
								.reasonStyle(selected: reason == self.newReason)
                                .padding([.leading, .bottom])
                                .onTapGesture {
                                    self.newReason = reason
                            }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading){
                Text("For how long?")
                    .font(.subheadline)
                //.padding()
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Image(systemName: "timer")
                        Text("\(self.displayTime)")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                    }//.padding()
                    TimeSliderView(time: self.$time)
                        .frame(height: 60)
                        .padding([.top, .bottom, .trailing])
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    let time = Int(gesture.location.x)/(Int(UIScreen.main.bounds.width)/11)
                                    if time > 11{
                                        self.time = 11
                                    }
                                    else if time < 0{
                                        self.time = 0
                                    }
                                    else{
                                        self.time = time
                                    }
                            }
                    )
                }
            }.padding(.leading)
            
            Button(action: {
                //to do
            }){
                Text("Notify All")
            }
            .wideButtonStyle(color: getColor(self.newStatus))
            Spacer()
        }
		.background(Color(UIColor.secondarySystemBackground))
		.edgesIgnoringSafeArea(.bottom)
		.onDisappear {
            self.fire.saveState(user: self.fire.profile, status: self.newStatus, reason: self.newReason, end: self.newEnd())
            self.fire.saveCustomReasons(reasons: self.reasons)
        }
        .onAppear {
            self.newReason = self.fire.profile.reason
            self.newStatus = self.fire.profile.status
            self.reasons = self.fire.getCustomReasons()
        }
        .onReceive(timer){ input in
            self.currentTime = input
        }
    }
    
    @State var currentTime = Date()
    //updates every 15 seconds - can update later
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    
    private func newEnd() -> Date {
        //let calendar = Calendar.autoupdatingCurrent
        //let date = Date()
        //let components = calendar.dateComponents([.hour, .minute], from: date)
        var intervalTime: Date{
            switch time{
            case 0:
                return Date().addingTimeInterval(10*60) //10 minutes
            case 1:
                return Date().addingTimeInterval(15*60) //15 minutes
            case 2:
                return Date().addingTimeInterval(20*60) //20 minutes
            case 3:
                return Date().addingTimeInterval(30*60) //30 minutes
            case 4:
                return Date().addingTimeInterval(45*60) //45 minutes
            case 5:
                return Date().addingTimeInterval(60*60) //1 hour
            case 6:
                return Date().addingTimeInterval(120*60) //2 hours
            case 7:
                return Date().addingTimeInterval(180*60) //3 hours
            case 8:
                return Date().addingTimeInterval(240*60) //4 hours
            case 9:
                return Date().addingTimeInterval(360*60) //6 hours (a while)
            case 10:
                return Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!//until midnight
            default:
                return fire.profile.end
            }
        }
        return intervalTime
    }
}

struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView().environmentObject(Fire())
    }
}
