//
//  Test_Delete.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/21/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct Test_Delete: View {
	var body: some View {
		HStack{
			Spacer()
			VStack{
				Spacer()
				Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
					.background(Color(UIColor.systemBackground))
				Spacer()
			}
		}.edgesIgnoringSafeArea(.all)
			.background(Color(UIColor.secondarySystemBackground))
		
	}
}

struct Test_Delete_Previews: PreviewProvider {
	static var previews: some View {
		Test_Delete().environment(\.colorScheme, .light)
	}
}
