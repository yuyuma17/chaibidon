//
//  WaitBiViewController.swift
//  chaibidon
//
//  Created by 陳姿穎 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class BiWaitViewController: UIViewController {
    
    var biWaitStateTimer: Timer?
    var biVC: BiViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repeatToGet()
    }

}

extension BiWaitViewController {
    
    func repeatToGet() {
        
        biWaitStateTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.getWaitingState()
        }
    }
    
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
                    if let biWaitState = try? JSONDecoder().decode(BiWait.self, from: data) {
                        print(biWaitState)
                        if biWaitState.data == 2 {
                            self.biWaitStateTimer?.invalidate()
                            DispatchQueue.main.async {
                                self.dismiss(animated: true) {
                                    self.biVC?.startTimer()
                                }
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func passToBi() {
        if let biVC = self.storyboard?.instantiateViewController(withIdentifier: "biVC") as? BiViewController {
            self.navigationController?.pushViewController(biVC, animated: true)
        }
    }
    
    
}
