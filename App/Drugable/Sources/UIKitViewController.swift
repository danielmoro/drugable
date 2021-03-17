//
//  UIKitViewController.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/17/21.
//

import UIKit

class UIKitViewController: UIViewController {

    let label = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(label)
        label.setTitle("Dismiss", for: .normal)
        label.setTitleColor(.red, for: .normal)
        label.addTarget(self, action: #selector(dismissButton(_:)), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        label.frame = .init(x: 10, y: 10, width: 100, height: 100)
    }
    
    @objc func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
