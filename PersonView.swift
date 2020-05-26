//
//  PersonView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

enum Status{
    case red, yellow, green
}

struct PersonView: View {
    @EnvironmentObject var fire: Fire
    
    let name: String
    let status: Int
    //@State private var uStatus: Int = -1
    let reason: String
    
    let endTime: TimeInterval //set by user (additional time + current time)
    let startTime: TimeInterval //set on save (current time)
    @State private var currentTime: TimeInterval = Date().timeIntervalSince1970 //NOW –– updating on timer
    
    let id: String
    let timerInterval: Double //how often to refresh timer
    
    var progress: Float{
        return 0.4
    }
    
    var countdown: String{
        var ret = ""
        //there is a reason
        if(!reason.isEmpty){
            ret = reason + ", "
            switch status{
            case 0:
                ret += "free "
            case 1:
                ret += "quiet "
            case 2:
                ret += "shoo "
            default:
                ret += "nobody knows "
            }
        } else { //No reason
            switch status{
            case 0:
                ret += "Free "
            case 1:
                ret += "Quiet "
            case 2:
                ret += "Shoo "
            default:
                ret += "Nobody knows "
            }
        }
        
        let timeLeft = endTime - self.currentTime
        if timeLeft >= 8*60*60 {
            return ret + "all day"
        } else if timeLeft <= 0 {
            self.fire.noStatus(id)
            //self.color = Color.gray
            return "Nobody knows for a good while"
        }
        else if timeLeft >= 4*60*60 {
            return ret + "for a while"
        } else {
            let hours = Int(timeLeft/3600)
            let minutes = Int((timeLeft/60).truncatingRemainder(dividingBy: 60))
            return ret + "for " + (hours>0 ? "\(hours) hour\(hours == 1 ? "" : "s")": "") + (hours > 0 && minutes > 0 ? ", " : "") + (minutes>0 ? "\(minutes) minute\(minutes == 1 ? "" : "s")": "")
        }
    }
    
    var body: some View {
        ZStack{
            color.animation(.easeInOut)
            
            HStack{
                VStack(alignment: .leading, spacing: 0){
                    Text(self.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.systemBackground))
                    
                    Text(self.countdown)
                        .font(.headline)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            //self.currentTime = getCountdownTime(from: self.endTime)
            //self.uStatus = self.status
            Timer.scheduledTimer(withTimeInterval: self.timerInterval, repeats: true) { _ in
                self.currentTime = Date().timeIntervalSince1970 //will update current time
            }.tolerance = (self.timerInterval * 0.2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width)
        .fixedSize(horizontal: true, vertical: true)
        .padding(.vertical, 8)
        .shadow(radius: 4, y: 4)
    }
    
    var color: Color{
        switch status {
        case 0:
            return Color.green
        case 1:
            return Color.yellow
        case 2:
            return Color.red
        default:
            return Color.gray
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(name: "Alex", status: 0, reason: "Working", endTime: Date().addingTimeInterval(8*60+1).timeIntervalSince1970, startTime: Date().timeIntervalSince1970, id: "alex", timerInterval: 5).environmentObject(Fire())//.environment(\.colorScheme, .dark)
    }
}
