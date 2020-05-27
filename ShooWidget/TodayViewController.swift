//
//  TodayViewController.swift
//  ShooWidget
//
//  Created by Benjamin Schiff on 5/26/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftUI

class TodayViewController: UIViewController, NCWidgetProviding {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width:self.view.frame.size.width, height: 250)
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode,
                                          withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 350)
        } else if activeDisplayMode == .compact {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 250)
        }
    }
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
       let hostingController = UIHostingController(coder: coder, rootView: WidgetView())
        hostingController!.view.backgroundColor = UIColor.clear;
        return hostingController
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
