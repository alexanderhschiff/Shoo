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
    
    @State private var reasons = ["+ Custom", "👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    @State private var newEnd = Date() //Need to figure out how to do the date....
    @State private var newStatus: Int = 0
    @State private var newReason: String = ""
    
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
                        ForEach(reasons, id: \.self){ reason in
                            Text(reason)
                                .reasonStyle()
                                .padding([.leading, .bottom])
                                .onTapGesture {
                                    if reason == "+ Custom" {
                                        self.custom = true
                                    } else {
                                        //set view
                                        self.newReason = reason
                                    }
                            }
                        }
                    }
                }
            }.padding(.top)
            
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
                    TimeSliderView(time: self.$time)
                        .frame(height: 60)
                        .offset(y: 5)
                }
            }
            .padding()
            
            Button(action: {
                //to do
            }){
                Text("Notify All")
            }
            .wideButtonStyle(color: getColor(self.newStatus))
            
            Spacer()
        }.onDisappear {
            //self.fire.saveState(user: fire.profile, reason: self.newReason, status: self.newStatus, end: self.newEnd)
            self.newStatus = 0
        }
        .onAppear {
            self.newReason = self.fire.profile.reason
            self.newStatus = self.fire.profile.status
        }
        /*.alert(isPresented: $custom,  TextAlert(title: "+ Custom", action: { response in
         if let response = response {
         self.reasons.insert(response, at: 1)
         }
         }))*/
    }
}

struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView()
    }
}
