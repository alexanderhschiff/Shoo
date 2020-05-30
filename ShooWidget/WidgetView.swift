//
//  WidgetView.swift
//  ShooWidget
//
//  Created by Benjamin Schiff on 5/26/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct WidgetView: View {
    let size = 3
    
    var body: some View {
        GeometryReader { geo in
            HStack{
                
                CircleStatusView(radius: min(geo.size.height, geo.size.width/CGFloat(self.size)), status: 2, initial: "B")
                .padding()
            }
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
