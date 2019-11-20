//
//  HomeViewController.swift
//  chaibidon
//
//  Created by 黃士軒 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var chaiBiDon: [UIButton]! {
        didSet {
            for item in chaiBiDon {
                item.layer.cornerRadius = item.frame.width / 2
                item.clipsToBounds = true
            }
        }
    }
    @IBOutlet var chaibi: UIImageView! {
        didSet {
            chaibi.layer.cornerRadius = chaibi.frame.width / 2
            chaibi.clipsToBounds = true
        }
    }
    

}
