//
//  TimeSliderView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/15/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct TimeSliderView: View {
    @Binding var time: Int

    let num = 11

    var body: some View {
        GeometryReader{ geo in
            HStack(spacing: 2){
                ForEach(0..<11){ number in
                    Rectangle()
                        .foregroundColor(number > self.time ? Color.gray : Color.white)
                        .frame(width: geo.size.width/CGFloat(self.num)-2, height: 50)
                        .onTapGesture {
                            self.time = number
                    }
                }
            }
            //.clipShape(Capsule())
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .frame(width: geo.size.width)
            .shadow(radius: 3)
        }
        
    }
}

struct TimeSliderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            TimeSliderView(time: .constant(9))
        }
    }
}
