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
	
	let name: String
	let status: Int
	let reason: String
	let endTime: Date
	
	var progress: Float{
		return 0.4
	}
	
	var countdown: String{
		let now = Date()
		
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .full
		formatter.allowedUnits = [.day, .hour, .minute, .second]
		formatter.maximumUnitCount = 1
		
		var ret = ""
		
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
				ret += "Nobody knows for "
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
		return ret + (formatter.string(from: now, to: endTime) ?? "No time")
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
			return Color.red
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
				ProgressView(progress: 0.75, width: 7)
					.foregroundColor(Color(UIColor.systemBackground))
					.frame(width: 60, height: 60)
			}
			.padding()
		}
		.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
			//.overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(color, lineWidth: 2))
			.padding(.horizontal)
			.frame(width: UIScreen.main.bounds.width, height: 120)
			.padding(.vertical, 8)
			
			.shadow(color: color, radius: 2)
	}
    @State var currentTime: Date
    let name: String
    let status: Int
    let reason: String
    let endTime: Date
    let startTime: Date
    
    var progress: Float{
        return 0.4
    }
    
    var countdown: String{
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1
        
        var ret = ""
        
        switch status{
        case 0:
            ret += "free for "
        case 1:
            ret += "shh for "
        case 2:
            ret += "shoo for "
        default:
            ret += "Error"
        }
        
        return reason + ", " + ret + (formatter.string(from: currentTime, to: endTime) ?? "No time")
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
        let denom = endTime.timeIntervalSince(startTime)
        let num = endTime.timeIntervalSince(currentTime)
        //print(num)
        //print(denom)
        return max(0, min(Float(num/denom), 1))
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
        
                    Spacer()
                }
                Spacer()
                ProgressView(progress: timePercentage(), width: 7)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .frame(width: 60, height: 60)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        //.overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(color, lineWidth: 2))
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: 120)
            //.shadow(color: color, radius: 2, x: 4, y: 4)
    }
}

struct PersonView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack{
			Color.white
			
			PersonView(name: "Alexander", status: 0, reason: "Watching TV and Tv and TV TV", endTime: Date().addingTimeInterval(13800))
		}
		
	}
}
