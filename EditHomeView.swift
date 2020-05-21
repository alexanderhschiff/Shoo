//
//  EditHomeView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import CodeScanner

struct EditHomeView: View {
    @EnvironmentObject var fire: Fire
    @Environment(\.colorScheme) var colorScheme
    
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 1 else { return }
            
            dump(details)
            let newID = details[0]
            if fire.testHouse(newID) {
            let oldID = fire.profile.house
            fire.profile.house = newID
            fire.updateHouse(fire.profile, oldID)
            }
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
    //creates a qr code and inverts colors if black background -- ALEX I can potentially change the colors but let me know
    private func createCode() -> UIImage {
        let myString = fire.profile.house
        let data = myString.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return  UIImage(systemName: "xmark.circle") ?? UIImage()}
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        if colorScheme == .dark {
            guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
            colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
            guard let outputInvertedImage = colorInvertFilter.outputImage else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
            guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
            maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
            guard let outputCIImage = maskToAlphaFilter.outputImage else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
            let context = CIContext()
            guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
            return UIImage(cgImage: cgImage)
        }
        else{
            let context = CIContext()
            guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
            return UIImage(cgImage: cgImage)
        }
    }
    
    var modes = ["Join", "Share"]
    @State private var mode = 0
    @State private var isShowingScanner = false
    
    var body: some View {
        VStack{
            Picker(selection: $mode, label: Text("Mode")){
                ForEach(0..<modes.count){
                    Text(self.modes[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            //if share, present this view under
            if(mode == 1){
                Image(uiImage: createCode())
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
                //if join, show this view under
            else{
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        self.isShowingScanner = true
                }
            }
        }.sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "testHouse", completion: self.handleScan)
        }
    }
    
    
    struct EditHomeView_Previews: PreviewProvider {
        static var previews: some View {
            EditHomeView()
        }
    }
}
