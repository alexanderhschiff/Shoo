//
//  HandleView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct HandleView: View {
    var body: some View {
        VStack(alignment: .center){
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.gray)
                .frame(width: 50, height: 5)
                .opacity(0.5)
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.vertical)
    }
}

struct HandleView_Previews: PreviewProvider {
    static var previews: some View {
        HandleView()
    }
}
