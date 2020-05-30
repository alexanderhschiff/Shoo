//
//  ExtensionsAndModifiers.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/23/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI
import Foundation

struct Blur: UIViewRepresentable {
	var style: UIBlurEffect.Style = .systemMaterial
	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: style))
	}
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
}

struct BottomViewStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(.vertical, 20)
			.padding(.horizontal)
			.frame(width: UIScreen.main.bounds.width)
			.background(configuration.isPressed ? Blur(style: .extraLight): Blur(style: .systemUltraThinMaterial))
	}
}

struct PlusMinusStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		ZStack{
			Circle()
				.frame(width: 40, height: 40)
				.foregroundColor(configuration.isPressed ? Color.gray.opacity(0.3) : .clear)
				.scaleEffect(configuration.isPressed ? 1.05 : 1)
				.animation(Animation.easeOut(duration: 0.2))
			
			configuration.label
				.scaleEffect(configuration.isPressed ? 0.6 : 1)
				.animation(Animation.easeOut(duration: 0.25))
		}
	}
}

struct WideButtonStyle: ButtonStyle {
	let color: Color
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.font(.headline)
			.padding()
			.background(color)
			.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
			.animation(.spring())
			.foregroundColor(Color(UIColor.systemBackground))
			.scaleEffect(configuration.isPressed ? 0.9 : 1)
	}
}

struct StatusButtonStyle: ButtonStyle {
	let color: Color
	let selected: Bool
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.font(.system(size: 16, weight: .bold))
			.padding()
			.background(color)
			//.foregroundColor(Color(UIColor.systemBackground))
			.fixedSize(horizontal: true, vertical: false)
			.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
			.shadow(color: color, radius: (selected ?  4: 0), y: 2)
			.scaleEffect(configuration.isPressed ? 0.9 : 1)
			.scaleEffect(selected ? 1.1 : 1)
	}
}

struct Reason: ViewModifier {
	
	let selected: Bool
	
	func body(content: Content) -> some View {
		content
			.font(.headline)
			.padding()
			.background(selected == true ? Color(UIColor.systemBackground): Color.gray.opacity(0.7))
			.cornerRadius(20)
			.shadow(radius: 3, y: 4)
			.lineLimit(1)
			.fixedSize(horizontal: false, vertical: true)
	}
}

extension View{
	func reasonStyle(selected: Bool) -> some View{
		self.modifier(Reason(selected: selected))
	}
}

func buttonPressHaptic() {
	let generator = UIImpactFeedbackGenerator(style: .light)
	generator.impactOccurred()
}

func successHaptic() {
	let generator = UINotificationFeedbackGenerator()
	generator.notificationOccurred(.success)
}
