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
        startMoraGame()
    }
    
    @IBAction func enterBiGame(_ sender: UIButton) {
        enterBiGame()
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
            }
        }
        task.resume()
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
