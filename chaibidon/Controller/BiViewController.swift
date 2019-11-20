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
    var countDownTimer: Timer?
    var answerPoint: Int = 0
    var repeatToGetResultTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
    }
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var myAnswerImage: UIImageView!
    @IBOutlet var enemyAnswerImage: UIImageView!
    
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
        let answer = BiAnswer(name: "123我", answer: answerPoint)
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
                            DispatchQueue.main.async {
                                self.drawButton.isEnabled = true
                            }
                            
                        }
                    }
                }
            }.resume()
        }
    }
    
}
