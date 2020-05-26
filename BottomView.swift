//
//  BottomView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
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
        let remainingTime = self.fire.profile.end - currentTime
        if remainingTime <= 0 {
            self.fire.noStatus(self.fire.profile.uid)
        }
        if remainingTime > 8*60*60 {
            return ret + "all day"
        } else if remainingTime > 4*60*60 || remainingTime <= 0 {
            return ret + "a while"
        } else {
            let hours = Int(remainingTime/3600)
            let minutes = Int((remainingTime/60).truncatingRemainder(dividingBy: 60))
            return ret + (hours>0 ? "\(hours) hour\(hours == 1 ? "" : "s")": "") + (hours > 0 && minutes > 0 ? ", " : "") + (minutes>0 ? "\(minutes) minute\(minutes == 1 ? "" : "s")": "")        }
    }
    
    func timePercentage() -> Float {
        let totalTime = self.fire.profile.end - self.fire.profile.start
        let timeRemaining = self.fire.profile.end - currentTime
        if(timeRemaining < 0){
            self.fire.noStatus(self.fire.profile.uid)
        }
        let ret = Float(timeRemaining/totalTime)
        return ((ret >= 0 && ret <= 1) ? 1 - ret : 0)
    }
    
    @EnvironmentObject var fire: Fire
    @State private var currentTime = Date().timeIntervalSince1970
    
    @Binding var more: Bool
    @Binding var eType: presentSheet
    
    var body: some View {
        VStack(spacing: 0){
            Button(action: {
                self.more = true
                self.eType = .more
            }){
                HStack{
                    VStack(alignment: .leading){
                        Text("YOU")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.secondary)
                        Text(countdown)
                            .lineLimit(1)
                            .font(.system(size: 20))
                            .foregroundColor(getColor(self.fire.profile.status))
                    }
                    Spacer()
                }
                .padding(.vertical)
                
            }.buttonStyle(BottomViewStyle())
            
            Divider()
            
            HStack{
                Group{
                    Spacer()
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
                }
                Group{
                    Spacer()
                    Divider().frame(height: 40)
                    Spacer()
                }
                Group{
                    Button(action: {
                        self.fire.quickUpdateTime(1, profile: self.fire.profile)
                        self.currentTime = Date().timeIntervalSince1970
                    }){
                        Image(systemName: "plus")
                    }
                    .buttonStyle(PlusMinusStyle())
                    Spacer()
                    Button(action: {
                        self.fire.quickUpdateTime(-1, profile: self.fire.profile)
                        self.currentTime = Date().timeIntervalSince1970
                    }){
                        Image(systemName: "minus")
                    }
                    .buttonStyle(PlusMinusStyle())
                    Spacer()
                }
            }
            .font(.headline)
            .padding()
            .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
            .frame(width: UIScreen.main.bounds.width)
            .background(Blur(style: .systemUltraThinMaterial))
        }.onAppear {
            self.currentTime = Date().timeIntervalSince1970
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                self.currentTime = Date().timeIntervalSince1970
            }.tolerance = 2.0
        }
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            VStack{
                Spacer()
                BottomView(more: .constant(false), eType: .constant(.more)).environmentObject(Fire())
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}
