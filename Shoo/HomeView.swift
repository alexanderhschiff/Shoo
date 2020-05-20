//
//  HomeView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var fire: Fire
    @State private var backgroundColor = Color.red
    @State private var addUserView = false
    @State private var more = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 0){
                        HStack{
                            Text("Home")
                                .fontWeight(.heavy)
                                .font(.largeTitle)
                            Spacer()
                            Image(systemName: "person.badge.plus.fill")
                                .font(.title)
                                .onTapGesture {
                                    self.addUserView = true
                            }
                        }
                        FreePeopleView(freePeople: self.fire.mates.count)
                            .font(.headline)
                    }
                    .padding([.horizontal, .top])
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack{
                            ForEach(self.fire.mates) { mate in
                                PersonView(name: mate.name, status: mate.status, reason: mate.reason, endTime: mate.end)
                            }
                            /*ForEach(0..<8){ mate in
                                PersonView(name: "Alexander", status: mate%3, reason: "👨‍💻 Working", endTime: Date().addingTimeInterval(TimeInterval(mate*1300)))
                            }*/
                        }
                        
                    }
                    
                }
            }
            
            BottomView(more: self.$more)
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 120)
        }.onAppear(perform: {
            self.fire.startListener()
        }).onDisappear(perform: {self.fire.stopListener()})
            .sheet(isPresented: self.$more){
                EditCardView()
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

/*
 import SwiftUI
 
 struct HomeView: View {
 @EnvironmentObject var fire: Fire
 @State private var backgroundColor = Color.red
 @State private var changeHouse = false
 
 @State private var time: Int = 10
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
 
 var body: some View {
 VStack(alignment: .leading, spacing: 0){
 VStack(alignment: .leading){
 HStack{
 Text("Home")
 .fontWeight(.heavy)
 .font(.largeTitle)
 Spacer()
 Image(systemName: "person.badge.plus.fill")
 .font(.title)
 .onTapGesture {
 self.changeHouse = true
 }
 }
 FreePeopleView(freePeople: fire.mates.count)
 .font(.headline)
 .offset(y: -10)
 }
 .padding([.horizontal, .top])
 
 ScrollView(.horizontal, showsIndicators: false){
 HStack{
 ForEach(fire.mates) { mate in
 PersonView(name: mate.name, status: mate.status, reason: mate.reason)
 }
 }
 .padding()
 }
 
 VStack(alignment: .leading){
 Text("Your status")
 .font(.title)
 .fontWeight(.bold)
 
 Text("What's happening")
 .font(.subheadline)
 }
 .padding(.horizontal)
 
 ScrollView(.horizontal, showsIndicators: false){
 HStack{
 ForEach(0..<10){ _ in
 VStack(alignment: .leading){
 Text("👩‍💻 Working")
 .reasonStyle()
 Text("📱 On the phone")
 .reasonStyle()
 }
 }
 }
 .padding(.horizontal)
 .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
 }
 
 Text("For how long?")
 .font(.subheadline)
 .padding(.horizontal)
 
 VStack(alignment: .leading, spacing: 0){
 HStack{
 Image(systemName: "timer")
 Text("\(self.displayTime)")
 .font(.headline)
 .fontWeight(.bold)
 }
 TimeSliderView(time: $time)
 }
 .padding()
 
 Spacer()
 }.onAppear(perform: {
 self.fire.startListener()
 })
 }
 }
 
 
 struct HomeView_Previews: PreviewProvider {
 static var previews: some View {
 HomeView()
 }
 }
 */
