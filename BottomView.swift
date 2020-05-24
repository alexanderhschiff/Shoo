//
//  BottomView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

func getColor (_ status: Int) -> Color {
    switch  status{
    case 0:
        return Color.green
    case 1:
        return Color.yellow
    case 2:
        return Color.red
    default:
        return Color.gray
    }}



struct BottomView: View {
    var countdown: String{
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1
        let format = DateFormatter()
        format.timeStyle = .medium
        //let date = Date(timeIntervalSince1970: time)
        var ret = ""
        
        //there is a reason
        if(!self.fire.profile.reason.isEmpty){
            ret = self.fire.profile.reason + ", "
            switch self.fire.profile.status{
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
            switch self.fire.profile.status{
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
        if time > 8*60*60 {
            return ret + "all day"
        } else if time > 4*60*60 || time <= 0 {
            return ret + "a while"
        } else {
            let hours = Int(time/3600)
            let minutes = Int((time/60).truncatingRemainder(dividingBy: 60))
            return ret + (hours>0 ? "\(hours) hour\(hours == 1 ? "" : "s")": "") + (hours > 0 && minutes > 0 ? ", " : "") + (minutes>0 ? "\(minutes) minute\(minutes == 1 ? "" : "s")": "")        }
    }
    
    func timePercentage() -> Float {
        let denom = self.fire.profile.end - self.fire.profile.start
        
        let num = time
        if(num < 0){
            self.fire.quickUpdateStatus(statInt: -1, profile: self.fire.profile)
        }
        //print(num)
        //print(denom)
        let ret = Float(num/denom)
        return ((ret >= 0 && ret <= 1) ? 1 - ret : 0)
    }
    
    @EnvironmentObject var fire: Fire
    @State private var time = Date().timeIntervalSince1970
    
    @Binding var more: Bool
    @Binding var eType: presentSheet
    
    var body: some View {
        VStack(spacing: 0){
            Button(action: {
                self.more = true
                self.eType = .more
            }){
                HStack {
                    ProgressView(progress: timePercentage(), width: 5)
                        .frame(width: 40, height: 40)
                        .foregroundColor(getColor(self.fire.profile.status))
                        .padding(.vertical)
                    
                    Text(countdown)
                        .font(.headline)
                        .foregroundColor(getColor(self.fire.profile.status))
                    Spacer()
                }
                
            }.buttonStyle(BottomViewStyle())
            
            Divider()
            
            HStack{
                Button("Free"){
                    self.fire.quickUpdateStatus(statInt: 0, profile: self.fire.profile)
                }
                .buttonStyle(StatusButtonStyle(color: Color.green))
                Spacer()
                Button("Quiet"){
                    self.fire.quickUpdateStatus(statInt: 1, profile: self.fire.profile)
                }
                .buttonStyle(StatusButtonStyle(color: Color.yellow))
                Spacer()
                Button("Shoo"){
                    self.fire.quickUpdateStatus(statInt: 2, profile: self.fire.profile)
                }
                .buttonStyle(StatusButtonStyle(color: Color.red))
                Group{
                    Spacer()
                    Divider().frame(height: 40)
                    Spacer()
                }
                Button(action: {
                    self.fire.quickUpdateTime(1, profile: self.fire.profile)
                    self.time = getCountdownTime(from: self.fire.profile.end)
                }){
                    Image(systemName: "plus")
                }
                .buttonStyle(PlusMinusStyle())
                Spacer()
                Button(action: {
                    self.fire.quickUpdateTime(-1, profile: self.fire.profile)
                    self.time = getCountdownTime(from: self.fire.profile.end)
                }){
                    Image(systemName: "minus")
                }
                .buttonStyle(PlusMinusStyle())
            }
            .font(.headline)
            .padding()
            .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
            .frame(width: UIScreen.main.bounds.width)
            .background(Blur(style: .systemUltraThinMaterial))
        }.onAppear {
            self.time = getCountdownTime(from: self.fire.profile.end)
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                self.time = getCountdownTime(from: self.fire.profile.end)
            }.tolerance = 2.0
        }
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
            VStack{
                Spacer()
                BottomView(more: .constant(false), eType: .constant(.more)).environmentObject(Fire())
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}
