//
//  WidgetView.swift
//  ShooWidget
//
//  Created by Benjamin Schiff on 5/26/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct WidgetView: View {
    var body: some View {
        VStack{
        Text("SwiftUI View")
            Text("Hey Alex")
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.red)
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
