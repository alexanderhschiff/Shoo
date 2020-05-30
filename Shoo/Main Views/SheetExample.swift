//
//  SheetExample.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/26/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct ExampleView: View {
    @State private var showingSheet = false
    @State private var counter = 0

    var body: some View {
        VStack(spacing: 50.0) {
            Text("Sheet has been shown \(counter) times.")

            Text("The counter will be incremented whenever the sheet's onDismiss closure is triggered.")
                .lineLimit(3)
                .multilineTextAlignment(.center)

            Button("Show Sheet") {
                self.showingSheet = true
            }
        }
        .padding()

        .sheet(isPresented: $showingSheet, onDismiss: {
            self.counter += 1
        }) {
            SheetView(isPresented: self.$showingSheet)
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 50.0) {
            Text("Here is the sheet view.")

            Button("Dismiss Sheet with Environment") {
                self.presentationMode.wrappedValue.dismiss()
            }

            Button("Dismiss Sheet with Binding") {
                self.isPresented = false
            }

            Text("Pull down to dismiss AND trigger 'onDismiss' action.")
                .lineLimit(3)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
