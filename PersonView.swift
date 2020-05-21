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
        
        return reason + ", " + ret + (formatter.string(from: now, to: endTime) ?? "No time")
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
            Color.white
            
            HStack{
                VStack(alignment: .leading, spacing: 0){
                    Text(self.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(color)
                    
                    Text(self.countdown)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
        
                    Spacer()
                }
                Spacer()
                ProgressView(progress: 0.75, width: 7)
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(color, lineWidth: 2))
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: 120)
        .shadow(radius: 5, y: 4)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white
            
            PersonView(name: "Alexander", status: 0, reason: "Watching TV", endTime: Date().addingTimeInterval(13800))
        }
        
    }
}
