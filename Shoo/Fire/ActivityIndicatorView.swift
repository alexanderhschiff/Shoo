import SwiftUI

struct ActivityIndicatorView<Content>: View where Content: View {
    
    @Binding var isPresented: Bool
    var message = "Working..."
    var content: () -> Content
    
    var body: some View {
        ZStack(alignment: .center) {
            
            self.content()
                .disabled(self.isPresented)
                .blur(radius: self.isPresented ? 2 : 0)
            
            VStack {
                Text(self.message).font(.body).fontWeight(.bold)
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            }
            .frame(width: UIScreen.main.bounds.width * 0.7,
                   height: UIScreen.main.bounds.height * 0.16)
                .background(Color.primary.colorInvert().opacity(1.0))
                .foregroundColor(Color.primary)
                .cornerRadius(8)
                .shadow(color: Color.primary.opacity(0.2), radius: 4, x: 2, y: 2)
                .opacity(self.isPresented ? 1 : 0)
                .offset(y: -UIScreen.main.bounds.height * 0.08)
        }
    }
    
}



struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}


