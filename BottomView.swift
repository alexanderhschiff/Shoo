//
//  BottomView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct BottomView: View {
	@EnvironmentObject var fire: Fire
	@State private var currentTime = Date().timeIntervalSince1970
	
	 var color: Color{
           switch self.fire.profile.status {
           case .yellow:
               return Color.yellow
           case .red:
               return Color.red
           default:
               return Color.green
           }
       }
       
       var actionElement: String{
           switch self.fire.profile.status{
           case .green:
               return "free"
           case .yellow:
               return "quiet"
           case .red:
               return "shoo"
           }
       }
       
       var timeElement: String{
           let timeLeft = self.fire.profile.end - self.currentTime
           if timeLeft > 8*60*60 {
               return "all day"
           } else if timeLeft <= 0 {
               self.fire.noStatus(self.fire.profile.uid)
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
           switch self.fire.profile.status {
           case .yellow:
               return "hand.raised.fill"
           case .red: //red
               return "hand.raised.slash.fill"
           default: //none
               return "hand.thumbsup.fill"
           }
       }
	
	@Binding var more: Bool
	@Binding var eType: presentSheet
	@GestureState var isDetectingLongPress = false
	
	var press: some Gesture {
		LongPressGesture(minimumDuration: 2)
			.updating($isDetectingLongPress) { currentstate, gestureState, transaction in
				gestureState = currentstate
				buttonPressHaptic()
				transaction.animation = Animation.easeIn(duration: 2.0)
		}
		.onEnded { finished in
			buttonPressHaptic()
			self.more = true
			self.eType = .more
		}
	}
	
	var shortPressGesture: some Gesture{
		LongPressGesture(minimumDuration: 0)
			.onEnded { _ in
				buttonPressHaptic()
				self.more = true
				self.eType = .more
				
		}
	}
	
	var tapPressGesture: some Gesture{
		press.exclusively(before: shortPressGesture)
	}
	
	@GestureState var plusAnimation = false
	
	var body: some View {
		VStack(spacing: 0){
			HStack{
				HStack(alignment: .center){
					Image(systemName: handType)
						.foregroundColor(color)
						.font(.system(size: 30))
						.frame(width: 30)
						//.shadow(color: color, radius: 1, y: 1)
					VStack(alignment: .leading, spacing: 0){
						HStack(alignment: .center){
							Text("YOU")
								.font(.system(size: 14, weight: .semibold))
								.foregroundColor(.secondary)
							Image(systemName: "chevron.up")
								.font(.system(size: 10, weight: .bold))
								.foregroundColor(.secondary)
						}
						Text("\(actionElement) for \(timeElement)")
							.lineLimit(1)
							.font(.system(size: 20, weight: .semibold))
							.foregroundColor(color)
					}
				}
				Spacer()
				HStack(spacing: 0){
					Button(action: {
						//none
					}){
						//increase tappable area
						ZStack{
							Circle().foregroundColor(.clear).frame(width: 40, height: 40)
							Image(systemName: "minus.circle.fill")
								.font(.system(size: 30))
						}
					}
					.highPriorityGesture(
						TapGesture()
							.onEnded{
								buttonPressHaptic()
								self.fire.timeSelection = max(self.fire.timeSelection - 1, 0)
								self.fire.quickUpdateTime(self.fire.timeSelection, profile: self.fire.profile)
								self.currentTime = Date().timeIntervalSince1970
					})
					.buttonStyle(PlusMinusStyle())
					
					Button(action: {
						//none
					}){
						//increase tappable area
						ZStack{
							Circle().foregroundColor(.clear).frame(width: 40, height: 40)
							Image(systemName: "plus.circle.fill")
								.font(.system(size: 30))
						}
					}
					.highPriorityGesture(
						TapGesture()
							.onEnded{
								buttonPressHaptic()
								self.fire.timeSelection = min(self.fire.timeSelection + 1, 10)
								self.fire.quickUpdateTime(self.fire.timeSelection, profile: self.fire.profile)
								self.currentTime = Date().timeIntervalSince1970
					})
					.buttonStyle(PlusMinusStyle())
				}
			}
			.padding()
			.background(self.isDetectingLongPress ? Blur(style: .prominent): Blur(style: .systemThinMaterial))
			.gesture(tapPressGesture)
			
			Divider().background(Color.primary)
			
			HStack(alignment: .center){
				Group{
					Spacer()
					Button("Free"){
                        self.fire.quickUpdateStatus(status: .green, profile: self.fire.profile)
						buttonPressHaptic()
					}
                    .buttonStyle(StatusButtonStyle(color: Color.green, selected: self.fire.profile.status == .green))
					Spacer()
					Button("Quiet"){
                        self.fire.quickUpdateStatus(status: .yellow, profile: self.fire.profile)
						buttonPressHaptic()
					}
                    .buttonStyle(StatusButtonStyle(color: Color.yellow, selected: self.fire.profile.status == .yellow))
					Spacer()
					Button("Shoo"){
                        self.fire.quickUpdateStatus(status: .red, profile: self.fire.profile)
						buttonPressHaptic()
					}
                    .buttonStyle(StatusButtonStyle(color: Color.red, selected: self.fire.profile.status == .red))
					Group{
						Spacer()
						Divider().frame(height: 40)
						Spacer()
					}
					Button("Remind"){
                        self.fire.remindHouse()
                        
					}
					.buttonStyle(StatusButtonStyle(color: Color.gray, selected: false))
					Spacer()
				}
			}
			.font(.headline)
			.padding([.horizontal, .top])
			.padding(.bottom, ((UIApplication.shared.windows.last?.safeAreaInsets.bottom)! == 0 ? 10 : 0))
			.padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
			.frame(width: UIScreen.main.bounds.width)
			.background(Blur(style: .systemThinMaterial))
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
		}.environment(\.colorScheme, .light)
	}
}
