//
//  ExtensionsAndModifiers.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/23/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
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
			.padding(.horizontal)
			.frame(width: UIScreen.main.bounds.width)
			.background(configuration.isPressed ? Blur(style: .prominent): Blur(style: .systemUltraThinMaterial))
    }
}

struct PlusMinusStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
			.padding()
			.background(Color(UIColor.systemBackground))
			.clipShape(Circle())
			.shadow(radius: 3, y: 2)
			.scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct WideButtonStyle: ButtonStyle {
    let color: Color
	let tapped: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.font(.headline)
			.padding()
			.background(color)
			.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
			.frame(width: tapped ? 100 : UIScreen.main.bounds.width)
			.animation(.spring())
            .foregroundColor(Color(UIColor.systemBackground))
			.scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct StatusButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(color)
            .foregroundColor(Color(UIColor.systemBackground))
            .fixedSize(horizontal: true, vertical: false)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(radius: 3, y: 2)
			.scaleEffect(configuration.isPressed ? 0.9 : 1)
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
