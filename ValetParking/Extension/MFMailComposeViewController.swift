//
//  MFMailComposeViewController.swift
//  LO FUSE
//
//  Created by Muhammad Kashif on 21/12/2017.
//  Copyright © 2017 Muhammad Kashif. All rights reserved.
//

import Foundation
import MessageUI

extension MFMailComposeViewController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor.white
    }
}
