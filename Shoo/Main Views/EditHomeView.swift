//
//  EditHomeView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct EditHomeView: View {
    @EnvironmentObject var fire: Fire
    
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    private func changeCode() -> UIImage {
        let code = generateQRCode(from: fire.houseID)
        return code
    }
    
    var modes = ["Join", "Share"]
    @State private var mode = 0
    
    var body: some View {
        VStack{
            Picker(selection: $mode, label: Text("Mode")){
                ForEach(0..<modes.count){
                    Text(self.modes[$0])
                }
                }.pickerStyle(SegmentedPickerStyle())
                .padding()
                
           Image(uiImage: changeCode())
           .resizable()
           .interpolation(.none)
           .scaledToFit()
           .frame(width: 200, height: 200)
        }
    }


struct EditHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EditHomeView()
    }
}
}
