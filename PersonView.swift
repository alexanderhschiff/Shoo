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

let name: String
let status: Status
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
let timeLeft = endTime - self.currentTime
if timeLeft > 8*60*60 {
return "all day"
} else if timeLeft <= 0 {
self.fire.noStatus(id)
//self.color = Color.gray
return "a while"
}
else if timeLeft > 4*60*60 {
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

@State private var expanded = false

var body: some View {
ZStack{
getColor(status: status)//.animation(.easeIn)

VStack{
HStack{
VStack(alignment: .leading, spacing: 0){
HStack{
Image(systemName: handType)
.font(.title)
//.foregroundColor(Color(UIColor.systemBackground))
.transition(.slide)
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
.onTapGesture {
withAnimation(.linear(duration: 0.1)){
self.expanded.toggle()
}
}

//expanded view
if true{
HStack{
Button(action: {
//to do
}){
Text("Remind")
.fontWeight(.bold)
.foregroundColor(Color(UIColor.systemBackground))
.padding(.horizontal)
}
.padding()
.overlay(RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(Color(UIColor.systemBackground), lineWidth: 5))
}
.padding()
//.padding(.horizontal)
.clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
}
}
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
PersonView(name: "Alex", status: .yellow, reason: "Working", endTime: Date().addingTimeInterval(8*60+6000).timeIntervalSince1970, startTime: Date().timeIntervalSince1970, id: "alex", timerInterval: 5).environmentObject(Fire())//.environment(\.colorScheme, .dark)
}
}
