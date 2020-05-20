//
//  BottomView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct Blur: UIViewRepresentable {
	var style: UIBlurEffect.Style = .systemMaterial
	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: style))
	}
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
}

struct BottomView: View {
	
	@Binding var more: Bool
    @Binding var eType: presentSheet
	
	var body: some View {
		VStack(spacing: 0){
			HStack {
				ProgressView(progress: 0.1, width: 5)
					.frame(width: 40, height: 40)
					.foregroundColor(.primary)
					.padding(.vertical)
				
				Text("Watching TV – Shoo for 2 hours")
					.font(.headline)
				Spacer()
			}
			.padding(.horizontal)
			.frame(width: UIScreen.main.bounds.width)
			.background(Blur(style: .systemMaterial))
			.onTapGesture {
				self.more = true
                self.eType = .more
			}
			
			HStack{
				Text("Free")
					.fontWeight(.bold)
					.padding()
					.background(Color.green)
					.cornerRadius(20)
					.foregroundColor(Color.white)
				Spacer()
				Text("Quiet")
					.fontWeight(.bold)
					.padding()
					.background(Color.yellow)
					.cornerRadius(20)
					.foregroundColor(Color.white)
				Spacer()
				Text("Shoo")
					.fontWeight(.bold)
					.padding()
					.background(Color.red)
					.cornerRadius(20)
					.foregroundColor(Color.white)
				Spacer()
				Image(systemName: "plus")
					.padding()
					.background(Color(UIColor.systemBackground))
					.cornerRadius(20)
					.foregroundColor(.primary)
				Spacer()
				Image(systemName: "minus")
					.padding()
					.background(Color(UIColor.systemBackground))
					.cornerRadius(20)
					.foregroundColor(.primary)
			}
			.font(.headline)
			.padding()
			.padding(.bottom)
			.frame(width: UIScreen.main.bounds.width)
			.background(Blur(style: .systemChromeMaterial))
			
		}
	}
}

struct BottomView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack{
			LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
            BottomView(more: .constant(false), eType: .constant(.more))
		}
	}
}
