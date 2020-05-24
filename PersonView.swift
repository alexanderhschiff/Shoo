//
//  MemberView.swift
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
    @Binding var t: Int
    
    var timeInterval: Double{
        switch t{
        case 0:
            return Date().timeIntervalSince1970 + 10*60 //10 minutes
        case 1:
            return Date().timeIntervalSince1970 + 15*60 //15 minutes
        case 2:
            return Date().timeIntervalSince1970 + 20*60 //20 minutes
        case 3:
            return Date().timeIntervalSince1970 + 30*60 //30 minutes
        case 4:
            return Date().timeIntervalSince1970 + 45*60 //45 minutes
        case 5:
            return Date().timeIntervalSince1970 + 60*60//1 hour
        case 6:
            return Date().timeIntervalSince1970 + 120*60 //2 hours
        case 7:
            return Date().timeIntervalSince1970 + 180*60 //3 hours
        case 8:
            return Date().timeIntervalSince1970 + 240*60 //4 hours
        case 9:
            return Date().timeIntervalSince1970 + 360*60 //6 hours (a while)
        case 10:
            return Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!.timeIntervalSince1970//until midnight
        default:
            return 0
        }
    }
    
    @EnvironmentObject var fire: Fire
    @State var time: TimeInterval = 0
    let name: String
    let status: Int
    let reason: String
    let endTime: TimeInterval
    let startTime: TimeInterval
    let id: String
    
    var progress: Float{
        return 0.4
    }
    
    var countdown: String{
        var ret = ""
        print("personView")
        print(time)
        //there is a reason
        if(!reason.isEmpty){
            ret = reason + ", "
            switch status{
            case 0:
                ret += "free for "
            case 1:
                ret += "quiet for "
            case 2:
                ret += "shoo for "
            default:
                ret += "nobody knows for "
            }
        } else { //No reason
            switch status{
            case 0:
                ret += "Free for "
            case 1:
                ret += "Quiet for "
            case 2:
                ret += "Shoo for "
            default:
                ret += "Nobody knows for "
            }
            
        }
        
        if timeInterval > 8*60*60 {
            return ret + "all day"
        } else if timeInterval > 4*60*60 {
            return ret + "a while"
        } else if timeInterval <= 0 {
            return ret + "fucked up time"
        }
        else {
            let hours = Int(timeInterval/3600)
            let minutes = Int((timeInterval/60).truncatingRemainder(dividingBy: 60))
            return ret + (hours>0 ? "\(hours) hour\(hours == 1 ? "" : "s")": "") + (hours > 0 && minutes > 0 ? ", " : "") + (minutes>0 ? "\(minutes) minute\(minutes == 1 ? "" : "s")": "")
        }
    }
    
    var body: some View {
        ZStack{
            //color
            color.blur(radius: 5)
            
            HStack{
                VStack(alignment: .leading, spacing: 0){
                    Text(self.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor.systemBackground))
                    
                    Text(self.countdown)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                Spacer()
                ProgressView(progress: timePercentage(), width: 7)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .frame(width: 60, height: 60)
            }
            .padding()
        }.onAppear {
            self.time = getCountdownTime(from: self.endTime)
            print("initialEnd: \(self.endTime)")
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                self.time = getCountdownTime(from: self.endTime)
                print("end: \(self.endTime)")
            }.tolerance = 2.0
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            //.overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(color, lineWidth: 2))
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width)
            .fixedSize(horizontal: true, vertical: true)
            .padding(.vertical, 8)
            .shadow(color: color, radius: 2)
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
    
    func timePercentage() -> Float {
        let totalTime = endTime - startTime
        let timeRemaining = time
        if (timeRemaining < 0){
            self.fire.noStatus(self.id)
        }
        //print(num)
        //print(denom)
        let ret = Float(timeRemaining/totalTime)
        return ((ret >= 0 && ret <= 1) ? 1 - ret : 0)
        //max(0, min(Float(timeRemaining/totalTime), 1))
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white
            
            //PersonView(currentTime: Date().addingTimeInterval(300), name: "Alexander", status: 0, reason: "Watching TV and Tv and TV TV", endTime: Date().addingTimeInterval(13800), startTime: Date())
        }
        
    }
}
