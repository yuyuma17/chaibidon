//
//  WaitBiViewController.swift
//  chaibidon
//
//  Created by 陳姿穎 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class WaitBiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension WaitBiViewController {
    
    func getWaitingState() {
        let address = "https://c9aa79d8.ngrok.io/api/vs/login"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                if let response = response as? HTTPURLResponse {
                    print("status code: \(response.statusCode)")
                    if let wannaLuhseinData = try? JSONDecoder().decode(WannaLuHseinData.self, from: data) {
                        self.wannaLuhseinData = wannaLuhseinData
                    }
                }
            }.resume()
        }
    }
    
}
