//
//  DonViewController.swift
//  chaibidon
//
//  Created by 陳姿穎 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit
import WebKit

class DonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "")!
        let request = URLRequest(url: url)
        donWeb.load(request)
    }

    @IBOutlet var donWeb: WKWebView!
    
}
