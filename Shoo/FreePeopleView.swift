//
//  FreePeopleView.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct FreePeopleView: View {
	
	var freePeople: Int
	
	var body: some View {
		switch freePeople{
		case 0:
			return Text("Nobody is free 😕")
		case 1:
			return Text("One person is free")
		default:
			return Text("\(freePeople) people are down to hang")
		}
		
	}
}

struct FreePeopleView_Previews: PreviewProvider {
	static var previews: some View {
		FreePeopleView(freePeople: 1)
	}
}
