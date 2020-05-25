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
    @EnvironmentObject var fire: Fire
	
	//difference from
	@State var timeInterval: TimeInterval = 1.0
	
	//time input
	let t: Double
	
    let name: String
    let status: Int
    let reason: String
    let endTime: TimeInterval
    let startTime: TimeInterval
    let id: String
	let timeRInterval: Double
    
    var progress: Float{
        return 0.4
    }
    
    var countdown: String{
        var ret = ""
        print("personView")
        print(timeInterval)
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
        
		let timeLeft = t - Date().timeIntervalSince1970
		
        if timeLeft >= 8*60*60 {
            return ret + "all day"
        } else if timeLeft >= 4*60*60 {
            return ret + "a while"
        } else if timeLeft <= 0 {
            return ret + "\(timeLeft)"
        }
        else {
			print("TimeInterval for comment: \(timeLeft)")
            let hours = Int(timeLeft/3600)
            let minutes = Int((timeLeft/60).truncatingRemainder(dividingBy: 60))
            return ret + (hours>0 ? "\(hours) hour\(hours == 1 ? "" : "s")": "") + (hours > 0 && minutes > 0 ? ", " : "") + (minutes>0 ? "\(minutes) minute\(minutes == 1 ? "" : "s")": "")
        }
    }
	
    var body: some View {
        ZStack{
            //color
            color
            
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
        }
		/*.onAppear {
			self.timeInterval = getCountdownTime(from: self.endTime)
			print("InitialendTime: \(self.endTime)")
            //print("initialEnd: \(self.endTime)")
			Timer.scheduledTimer(withTimeInterval: self.timeRInterval, repeats: true) { _ in
				self.timeInterval = getCountdownTime(from: self.endTime)
                print("endTime: \(self.endTime)")
				//print("timeInterval: \(self.timeInterval)")
			}.tolerance = (self.timeRInterval * 0.2)
        }*/
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
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
        let timeRemaining = timeInterval
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
