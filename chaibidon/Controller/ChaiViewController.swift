//
//  ChaiViewController.swift
//  chaibidon
//
//  Created by 黃士軒 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class ChaiViewController: UIViewController {

    var roomData: RoomData?
    var user_a_option: Int?
    var roomID: Int?
    var vc: HomeViewController?
    
    var repeatTimer: Timer?
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    var myScore: Int?
    var otherScore: Int?
    var myName: String?
    
    @IBOutlet weak var endingGameView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var otherScoreLabel: UILabel!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var otherSelectImage: UIImageView!
    @IBOutlet weak var mySelectImage: UIImageView!
    @IBOutlet weak var tauntImageView: UIImageView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var otherNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myNameLabel.text = myName
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        monitorRoomStatus()
        repeatToGetResult()
    }
    
    @IBAction func pressScissors(_ sender: UIButton) {
        user_a_option = 1

        sendSelection()
        monitorRoomStatus()
    }
    
    @IBAction func pressRock(_ sender: UIButton) {
        user_a_option = 2

        sendSelection()
        monitorRoomStatus()
    }
    
    @IBAction func pressPaper(_ sender: UIButton) {
        user_a_option = 3

        sendSelection()
        monitorRoomStatus()
    }
    

}

extension ChaiViewController {
    
    func repeatToGetResult() {
        repeatTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            self.monitorRoomStatus()
        }
    }
    
    func monitorRoomStatus() {
        
        if let url = URL(string: "https://85fb8eaa.ngrok.io/api/pss/watch/\(roomID!)") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                
                if let response = response as? HTTPURLResponse {
                    print("status code: \(response.statusCode)")
                }
                
                guard let data = data else { return }
                do {
                    let tryCatchData = try JSONDecoder().decode(RoomData.self, from: data)
                    self.roomData = tryCatchData
                    
                    DispatchQueue.main.async {
                        self.activityIndicatorView.removeFromSuperview()
                        if self.roomData?.data.records.user_a_score == 2 || self.roomData?.data.records.user_b_score == 2 {
                            self.endingGameView.isHidden = false
                        }
                        self.myScoreLabel.text = "\(self.roomData?.data.records.user_a_score ?? 0)"
                        self.otherScoreLabel.text = "\(self.roomData?.data.records.user_b_score ?? 0)"
                        self.roundLabel.text = "\(self.roomData?.data.records.round_id ?? 1)"
                        self.otherNameLabel.text = self.roomData?.data.records.user_b_name
                        
                        if self.roomData?.data.records.user_a_option == "1" {
                            self.mySelectImage.image = UIImage(named: "scissors")
                        } else if self.roomData?.data.records.user_a_option == "2" {
                            self.mySelectImage.image = UIImage(named: "rock")
                        } else if self.roomData?.data.records.user_a_option == "3" {
                            self.mySelectImage.image = UIImage(named: "paper")
                        } else if self.roomData?.data.records.user_a_option == nil {
                            self.mySelectImage.image = UIImage(named: "nothing")
                        }
                        
                        
                        if self.roomData?.data.records.user_b_option == "1" {
                            self.otherSelectImage.image = UIImage(named: "scissors")
                        } else if self.roomData?.data.records.user_b_option == "2" {
                            self.otherSelectImage.image = UIImage(named: "rock")
                        } else if self.roomData?.data.records.user_b_option == "3" {
                            self.otherSelectImage.image = UIImage(named: "paper")
                        } else if self.roomData?.data.records.user_b_option == nil {
                            self.otherSelectImage.image = UIImage(named: "nothing")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                    let string = String(data: data, encoding: .utf8)
                    print(string!)
                }
            }.resume()
        }
    }
    
    func sendSelection() {
        
        let passingData = GameOption(user_name: myName!, user_option: user_a_option!)
        
        guard let uploadData = try? JSONEncoder().encode(passingData) else {
            return
        }
        let url = URL(string: "https://85fb8eaa.ngrok.io/api/pss/send/\(roomID!)")!

        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in

            if let error = error {
                print ("error: \(error)")
                return
            }

            if let response = response as? HTTPURLResponse {
                print("status codeddd: \(response.statusCode)")
            }

            if let mimeType = response?.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print (dataString)
            }
        }
        task.resume()
    }
}
