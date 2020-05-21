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
                    .statusButtonStyle(color: Color.green)
                Spacer()
                Text("Quiet")
                    .statusButtonStyle(color: Color.yellow)
                Spacer()
                Text("Shoo")
                    .statusButtonStyle(color: Color.red)
                Spacer()
                Image(systemName: "plus")
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "minus")
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .foregroundColor(.primary)
            }
            .font(.headline)
            .padding([.horizontal, .top])
                //.padding(.bottom, 20)
                .frame(width: UIScreen.main.bounds.width)
                .background(Blur(style: .systemChromeMaterial))
        }
        
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
            VStack{
                Spacer()
                BottomView(more: .constant(false), eType: .constant(.more))
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}
