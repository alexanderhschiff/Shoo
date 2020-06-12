//
//  PersonView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

func getColor(status: Status) -> Color{
    switch status {
    case .yellow:
        return Color.yellow
    case .red:
        return Color.red
    default:
        return Color.green
    }
}

struct PersonView: View {
    @EnvironmentObject var fire: Fire
    
    @State private var expanded = false
    
    let name: String
    let id: String
    let reason: String
    let status: Status
    let end: Double
    let start: Double
    let pushToken: String
    
    
    init(mate: Mate) {
        self.name = mate.name
        self.id = mate.id
        self.reason = mate.reason
        self.status = mate.status
        self.end = mate.end
        self.start = mate.start
        self.pushToken = mate.pushToken
    }
    
    init(id: String, name: String, reason: String, status: Status, end: Double, start: Double, pushToken: String) {
        self.name = name
        self.id = id
        self.reason = reason
        self.status = status
        self.end = end
        self.start = start
        self.pushToken = pushToken
    }
    
    @State private var currentTime: TimeInterval = Date().timeIntervalSince1970 //NOW –– updating on timer
    
    let timerInterval: Double = 5 //how often to refresh timer
    
    var progress: Float{
        return 0.4
    }
    
    var actionElement: String{
        switch status{
        case .green:
            return "free"
        case .yellow:
            return "quiet"
        case .red:
            return "shoo"
        }
    }
    
    var timeElement: String{
        let timeLeft = end - self.currentTime
        if timeLeft > 8*60*60 {
            return "all day"
        } else if timeLeft <= 0 {
            self.fire.noStatus(id)
            //self.color = Color.gray
            return "a while"
        }
        else if timeLeft > 5*60*60 {
            return "a while"
        } else {
            let hours = Int(timeLeft/3600)
            let minutes = Int((timeLeft/60).truncatingRemainder(dividingBy: 60))
            return (hours>0 ? "\(hours)h" : "") + (minutes>0 ? "\(minutes)m" : "")
            //return (hours>0 ? "\(hours) hour\(hours == 1 ? "" : "s")": "") + (hours > 0 && minutes > 0 ? ", " : "") + (minutes>0 ? "\(minutes) minute\(minutes == 1 ? "" : "s")": "")
        }
    }
    
    var handType: String{
        switch status {
        case .yellow: //yellow
            return "hand.raised.fill"
        case .red: //red
            return "hand.raised.slash.fill"
        case .green: //none
            return "hand.thumbsup.fill"
        }
    }
    
    var body: some View {
        ZStack{
            getColor(status: self.status)
            
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        HStack{
                            Image(systemName: handType)
                                .font(.title)
                            //.foregroundColor(Color(UIColor.systemBackground))
                            Text(self.name)
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.semibold)
                                //.font(.largeTitle)
                                //.fontWeight(.bold)
                                //.foregroundColor(Color(UIColor.systemBackground))
                                .lineLimit(1)
                        }
                        
                        Text(self.reason)
                            .font(.system(.title, design: .rounded))
                            //.font(.headline)
                            //.fontWeight(.bold)
                            //.foregroundColor(Color(UIColor.systemBackground))
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(self.actionElement) for")
                            .font(.system(.headline, design: .rounded))
                        Text(self.timeElement)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                    }
                    .padding(10)
                }
                .padding()
                .onAppear {
                    //self.currentTime = getCountdownTime(from: self.endTime)
                    //self.uStatus = self.status
                    Timer.scheduledTimer(withTimeInterval: self.timerInterval, repeats: true) { _ in
                        self.currentTime = Date().timeIntervalSince1970 //will update current time
                    }.tolerance = (self.timerInterval * 0.2)
                }
                
                
                //expanded view
                if expanded{
                    HStack{
                        Button(action: {
                            buttonPressHaptic(self.fire.reduceHaptics)
                            self.fire.remindMate(self.pushToken)
                        }){
                            /*HStack{
                             Spacer()
                             Text("Remind")
                             .font(.system(size: 15, weight: .bold, design: .default))
                             .foregroundColor(.primary)
                             Spacer()
                             }*/
                            Text("Remind")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                                .padding()
                                .padding(.horizontal)
                                .overlay(RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(Color.primary, lineWidth: 5))
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                        //.background(Color.primary.opacity(0.4))
                        .padding()
                        .transition(.slide)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    
                }
            }
        }
        .onTapGesture {
            //withAnimation(.linear(duration: 0.1)){
            buttonPressHaptic(self.fire.reduceHaptics)
            self.expanded.toggle()
            //}
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width)
        .padding(.vertical, 8)
        .fixedSize(horizontal: true, vertical: true)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(mate: Mate(id: "", name: "Benjamin", reason: "Testing", status: .green, end: Date().timeIntervalSince1970, start: Date().timeIntervalSinceReferenceDate, pushToken: "")).environmentObject(Fire())//.environment(\.colorScheme, .dark)
    }
}
