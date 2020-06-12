import SwiftUI
import CoreImage.CIFilterBuiltins
import CodeScanner
import AVFoundation

struct EditHomeView: View {
    @EnvironmentObject var fire: Fire
    @Environment(\.colorScheme) var colorScheme
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            successHaptic(fire.reduceHaptics)
            let details = code.components(separatedBy: "\n")
            guard details.count == 1 else { return }
            let newID = details[0]
            self.fire.testHouse(newID) { result in
                switch result {
                case .success(let exists):
                    if exists {
                        let oldID = self.fire.profile.house
                        self.fire.profile.house = newID
                        self.fire.updateHouse(self.fire.profile, oldID)
                        self.fire.startListener()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
        case .failure(let error):
            if error == .badInput {
                //na
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
    
    func checkPermission() -> Bool{
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied: return false
        case .authorized: return true
        case .restricted: return false
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                    self.camAuth = true
                } else {
                    print("Denied access to \(cameraMediaType)")
                }
            }
        default: return false
        }
        return false
    }
    
    var modes = ["Share", "Join"]
    @State private var mode = 0
    @State private var isShowingScanner = false
    @State private var camAuth: Bool = false
    
    
    @State private var showShareSheet: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
        ZStack{
            if mode == 1 {
                if camAuth {
                    CodeScannerView(codeTypes: [.qr], simulatedData: self.fire.profile.house, completion: self.handleScan).accessibility(hint: Text("Scans another user's QR code"))
                } else{
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }){
                        Text("Please enable camera access to join a house.")
                    }.accessibility(hint: Text("Links to settings enable camera access."))
                }
            } else {
                ZStack(alignment: .center){
                    VStack{
                        Image(uiImage: createCode())
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .padding()
                            .accessibility(label: Text("House QR Code"))
                        
                        Button(action: {
                            buttonPressHaptic(self.fire.reduceHaptics)
                            self.showShareSheet = true
                        }){
                            HStack{
                                Image(systemName: "square.and.arrow.up")
                                Text("Share the app")
                            }
                            .font(.headline)
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
                            .accessibility(hint: Text("Shares the app."))
                            .accessibility(label: Text("Share"))
                        }
                    }
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
                        buttonPressHaptic(self.fire.reduceHaptics)
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Done")
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    .accessibility(label: Text("Done"))
                    .padding()
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack{
                    Spacer()
                    Text("\(mode == 1 ? "Scan a housemate's code to join the house" : "Share the above code with housemates")")
                        .font(.headline)
                        .padding()
                        .background(Blur(style: .systemMaterial))
                        .background(self.reduceTransparency ? Color(UIColor.systemBackground) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
                    Spacer()
                }
            }
        }.highPriorityGesture(DragGesture())
            .background(Color(UIColor.secondarySystemBackground))
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                self.camAuth = self.checkPermission()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [appURL])
        }
        .onDisappear {
            self.fire.startListener()
        }
    }
    
    
    struct EditHomeView_Previews: PreviewProvider {
        static var previews: some View {
            EditHomeView().environmentObject(Fire()).environment(\.colorScheme, .dark)
        }
    }
}
