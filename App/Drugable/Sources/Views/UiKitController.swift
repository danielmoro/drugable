//
//  UiKitController.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/17/21.
//

import Foundation
import SwiftUI

struct UIKitController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIKitViewController {
        
        let viewController = UIKitViewController()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIKitViewController, context: Context) {
        //
    }
    
    
    typealias UIViewControllerType = UIKitViewController
    
    
}
