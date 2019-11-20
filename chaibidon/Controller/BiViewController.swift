//
//  BiViewController.swift
//  chaibidon
//
//  Created by 陳姿穎 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class BiViewController: UIViewController {

    var playerName: String?
    var initialTime: Int?
    var countDownTimer: Timer?
    var answerPoint: Int = 0
    var repeatToGetResultTimer: Timer?
    var winner: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let waitingVC = storyboard?.instantiateViewController(withIdentifier: "waitingVC") as? BiWaitViewController {
            waitingVC.biVC = self
            present(waitingVC, animated: false, completion: nil)
        }
    }
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var myAnswerImage: UIImageView!
    @IBOutlet var enemyAnswerImage: UIImageView!
    @IBOutlet var myName: UILabel! {
        didSet {
            myName.text = playerName!
        }
    }
    
    @IBOutlet var drawButton: UIButton!
    @IBAction func drawCard(_ sender: UIButton) {
        countDownTimer?.invalidate()
        timerLabel.text = "等待對方抽卡..."
        
        answerPoint = Int.random(in: 1...13)
        
        sender.isEnabled = false
        sender.backgroundColor = .darkGray
        
        myAnswerImage.image = UIImage(named: "\(answerPoint)")
        postRandomPoint()
        repeatToGetResult()
    }

}

extension BiViewController {
    
    func startTimer() {
        
        initialTime = 15
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.timerLabel.text = "剩餘時間： \(self.initialTime!) 秒"
            if self.initialTime != 0 {
                self.initialTime! -= 1
            } else {
                timer.invalidate()
                self.postRandomPoint()
                self.repeatToGetResult()
            }
        }
        
    }
    
    func postRandomPoint() {
        let answer = BiAnswer(name: playerName!, answer: answerPoint)
        guard let uploadData = try? JSONEncoder().encode(answer) else { return }
                
        let url = URL(string: "https://c9aa79d8.ngrok.io/api/vs/send")!
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
    
    func repeatToGetResult() {
        repeatToGetResultTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.getResult()
        }
    }
    
    func getResult() {
        let address = "https://c9aa79d8.ngrok.io/api/vs/watch"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                if let response = response as? HTTPURLResponse {
                    print("status code: \(response.statusCode)")
                    if let biResult = try? JSONDecoder().decode(BiResult.self, from: data) {
                        print(biResult)
                        if biResult.data.winner != "Not yet" {
                            self.repeatToGetResultTimer?.invalidate()
                            
                            if biResult.data.winner == "Nobody" {
                                self.winner = "平手"
                            } else {
                                self.winner = "\(biResult.data.winner) 勝利"
                            }
                            
                            for player in biResult.data.compares {
                                if player.name != self.playerName! {
                                    self.enemyAnswerImage.image = UIImage(named: "\(player.answer!)")
                                }
                            }
                            
                            DispatchQueue.main.async {
                                
                                let alertController = UIAlertController(title: self.winner!, message: nil, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "離開房間", style: .default, handler: { (alert) in
                                    self.drawButton.isEnabled = true
                                    self.drawButton.backgroundColor = UIColor(red: 16/255, green: 81/255, blue: 151/255, alpha: 1)
                                    self.myAnswerImage.image = UIImage(named: "back")
                                    self.myAnswerImage.image = UIImage(named: "back")
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
}
