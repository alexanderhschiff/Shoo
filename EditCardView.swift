//
//  EditCardView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

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

struct StatusButton: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()
            .background(color)
            .foregroundColor(Color(UIColor.systemBackground))
            .fixedSize(horizontal: true, vertical: false)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(radius: 3, y: 2)
    }
}

extension View{
    func statusButtonStyle(color: Color) -> some View{
        self.modifier(StatusButton(color: color))
    }
}



struct EditCardView: View {
    @EnvironmentObject var fire: Fire
    @State private var time: Int = 10
    
    @State private var addReason = ""
    @State private var reasons = ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    @State private var newEnd = Date() //Need to figure out how to do the date....
    @State private var newStatus: Int = 0
    @State private var newReason: String = ""
    
    func addReasonFunc() {
        let nR = addReason.trimmingCharacters(in: .whitespacesAndNewlines)
        dump(nR)
        guard nR.count > 0 else {
            addReason = ""
            custom = false
            return
        }
        
        reasons.insert(nR, at: 0)
        newReason = nR
        addReason = ""
        custom = false
        self.fire.saveCustomReasons(reasons: reasons)
    }
    
    private func dismissKeyboard() {
        let windows = UIApplication.shared.windows
        let keyWindows = windows.filter({$0.isKeyWindow})
        if (!keyWindows.isEmpty){
            let window = keyWindows.first
            window?.endEditing(true)
        }
        self.custom = false
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
    
    @State private var custom = false
    
    var body: some View {
        VStack(alignment: .leading){
            HandleView()
            
            Spacer()
            
            PersonView(name: fire.profile.name, status: newStatus, reason: newReason, endTime: newEnd)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10){
                Text("Your status")
                    .font(.subheadline)
                
                HStack{
                    Text("Free")
                        .statusButtonStyle(color: Color.green)
                        .onTapGesture {
                            self.newStatus = 0
                    }
                    Text("Quiet")
                        .statusButtonStyle(color: Color.yellow)
                        .onTapGesture {
                            self.newStatus = 1
                    }
                    Text("Shoo")
                        .statusButtonStyle(color: Color.red)
                        .onTapGesture {
                            self.newStatus = 2
                    }
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
                    HStack(spacing: 0){
                        if(self.custom){
                            TextField("Custom", text: $addReason, onCommit: addReasonFunc)
                                .reasonStyle()
                                .disableAutocorrection(true)
                                .padding([.leading, .bottom, .top])
                        }
                        else {
                            Text("+ Custom")
                                .reasonStyle()
                                .padding([.leading, .bottom])
                                .onTapGesture {
                                    self.custom = true
                            }
                        }
                        ForEach(reasons, id: \.self){ reason in
                            Text(reason)
                                .reasonStyle()
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
        }.onDisappear {
            self.fire.saveState(user: self.fire.profile, status: self.newStatus, reason: self.newReason, end: self.newEnd)
            self.fire.saveCustomReasons(reasons: self.reasons)
        }
        .onAppear {
            self.newReason = self.fire.profile.reason
            self.newStatus = self.fire.profile.status
            self.reasons = self.fire.getCustomReasons()
        }
    }
}


struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView().environmentObject(Fire())
    }
}
