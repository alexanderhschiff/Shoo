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
                if self.fire.testHouse(newID) {
                    print("3")
                    let oldID = self.fire.profile.house
                    self.fire.profile.house = newID
                    self.fire.updateHouse(self.fire.profile, oldID)
                    self.fire.startListener()
            }
            print("out of async")
            self.presentationMode.wrappedValue.dismiss()
        case .failure(let error):
            if error == .badInput {
                //link to settings with alert heres
            }
            print("Scanning failed \(error)")
        }
    }
    
    //creates a qr code and inverts colors if black background -- ALEX I can potentially change the colors but let me know
    private func createCode() -> UIImage {
        let myString = fire.profile.house
        let data = myString.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return UIImage(systemName: "xmark.circle") ?? UIImage()}
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
    
    
    var modes = ["Share", "Join"]
    @State private var mode = 0
    @State private var isShowingScanner = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            ZStack{
                if mode == 1 {
                    CodeScannerView(codeTypes: [.qr], simulatedData: self.fire.profile.house, completion: self.handleScan)
                } else {
                    ZStack(alignment: .center){
                        Image(uiImage: createCode())
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    }
                }
                
                VStack{
                    HStack{
                        Spacer()
                        Picker(selection: $mode, label: Text("Mode")){
                            ForEach(0..<modes.count){
                                Text(self.modes[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .highPriorityGesture(DragGesture())
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Text("Done")
                                .padding()
                                .background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }.highPriorityGesture(DragGesture())
        }
        .background(Color(UIColor.secondarySystemBackground))
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    
    struct EditHomeView_Previews: PreviewProvider {
        static var previews: some View {
            EditHomeView().environmentObject(Fire()).environment(\.colorScheme, .dark)
        }
    }
}
