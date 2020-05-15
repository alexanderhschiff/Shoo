//
//  Happening.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct Happening: ViewModifier {
	var body(content: Content) -> some View {
        content
	.frame(width: 20, height: 10)
    }
}

struct Happening_Previews: PreviewProvider {
    static var previews: some View {
        Happening()
    }
}
