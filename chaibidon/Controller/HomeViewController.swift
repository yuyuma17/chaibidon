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
        
        settingParallaxEffect(chaibi)
    }

    @IBOutlet weak var playerTextField: UITextField!
    
    @IBOutlet var chaiBiDon: [UIButton]! {
        didSet {
            for item in chaiBiDon {
                item.isEnabled = false
                item.backgroundColor = .lightGray
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
    
    @IBAction func checkContent(_ sender: UITextField) {
        if sender.text?.trimmingCharacters(in: .whitespaces) == "" {
            for item in chaiBiDon {
                item.isEnabled = false
                item.backgroundColor = .lightGray
            }
        } else if sender.text?.trimmingCharacters(in: .whitespaces).count == 1 {
            for item in chaiBiDon {
                item.isEnabled = true
                item.backgroundColor = .brown
            }
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
        
    }
    
}

extension HomeViewController {
    
    func settingParallaxEffect(_ view: UIView) {
        let horizonValue = UIScreen.main.bounds.width / 2
        let verticalValue = UIScreen.main.bounds.height / 4
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -horizonValue
        horizontal.maximumRelativeValue = horizonValue
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -verticalValue
        vertical.maximumRelativeValue = verticalValue
        
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [horizontal, vertical]
        view.addMotionEffect(motionGroup)
    }
    
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
        request.setValue("application/json", forHTTPHeaderField: "Accept")
                
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
                DispatchQueue.main.async {
                    if response.statusCode == 422 {
                        let alertController = UIAlertController(title: "使用者名稱重複！", message: nil, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let storyboard = UIStoryboard(name: "Bi", bundle: nil)
                        if let biNavi = storyboard.instantiateViewController(withIdentifier: "biNavi") as? UINavigationController {
                            if let destination = biNavi.viewControllers.first as? BiViewController {
                                destination.playerName = self.playerTextField.text!
                                self.present(biNavi, animated: true, completion: nil)
                            }
                        }
                    }
                }

            }
        }
        task.resume()
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
