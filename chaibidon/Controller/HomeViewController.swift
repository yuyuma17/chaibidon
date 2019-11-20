//
//  HomeViewController.swift
//  chaibidon
//
//  Created by 黃士軒 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var loginAndReceiveData: LoginAndReceiveData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var playerTextField: UITextField!
    
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
    
    @IBAction func toMoraGame(_ sender: UIButton) {
        
        self.startMoraGame()
        
        while self.loginAndReceiveData == nil {}
        
        let storyboard = UIStoryboard(name: "Chai", bundle: nil)
        let chaiVC = storyboard.instantiateViewController(identifier: "chaiVC") as! ChaiViewController
        
        chaiVC.roomID = self.loginAndReceiveData?.room.id
        chaiVC.myName = self.playerTextField.text!
        chaiVC.vc = self
        self.present(chaiVC, animated: true)
    }
    
    @IBAction func enterBiGame(_ sender: UIButton) {
        
        enterBiGame()
        
        let storyboard = UIStoryboard(name: "Bi", bundle: nil)
        if let biNavi = storyboard.instantiateViewController(withIdentifier: "biNavi") as? UINavigationController {
            if let destination = biNavi.viewControllers.first as? BiViewController {
                destination.playerName = playerTextField.text!
                present(biNavi, animated: true, completion: nil)
            }
        }
    }
    
}

extension HomeViewController {
    
    func startMoraGame() {
        
        let passingData = YourName(name: playerTextField.text!)
        
        guard let uploadData = try? JSONEncoder().encode(passingData) else {
            return
        }
        let url = URL(string: "https://85fb8eaa.ngrok.io/api/pss/login")!

        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in

            if let error = error {
                print ("error: \(error)")
                return
            }

            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print (dataString)
                self.decodeData(data)
            }
        }
        task.resume()
    }
    
    func decodeData(_ data: Data) {
        let decoder = JSONDecoder()
        if let data = try? decoder.decode(LoginAndReceiveData.self, from: data) {
            loginAndReceiveData = data
        }
    }
    
    func enterBiGame() {
        let passingData = YourName(name: playerTextField.text!)
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
                
        let url = URL(string: "https://c9aa79d8.ngrok.io/api/vs/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
                if let mimeType = response.mimeType,
                    mimeType == "application/json",
                    let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print ("got data: \(dataString)")
                }
            }
        }
        task.resume()
    }
}
