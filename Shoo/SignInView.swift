//
//  SignInView.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/16/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI

struct SignIn: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SignIn>) -> UIViewController {
        let vc = SignInVC()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
struct SignInView: View {
    var body: some View {
        SignIn()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
