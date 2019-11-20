//
//  BiViewController.swift
//  chaibidon
//
//  Created by 陳姿穎 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class BiViewController: UIViewController {

    var initialTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
    }
    
    @IBOutlet var timerLabel: UILabel!
    
    @IBAction func drawCard(_ sender: UIButton) {
        
        
    }
    

}


extension BiViewController {
    
    
    
    
    func startTimer() {
        
        initialTime = 15
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.timerLabel.text = "剩餘時間： \(self.initialTime!) 秒"
            if self.initialTime != 0 {
                self.initialTime! -= 1
            } else {
                timer.invalidate()
                //call API
            }
        }
        
    }
    
    
}
