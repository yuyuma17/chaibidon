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
    var user_b_option: Int? = 1
    var roomID: Int?
    var vc: HomeViewController?
    
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    var myScore: Int?
    var otherScore: Int?
    
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
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        monitorRoomStatus()
    }
    
    @IBAction func pressScissors(_ sender: UIButton) {
        mySelectImage.image = UIImage(named: "scissors")
        user_a_option = 1
        user_b_option = 1
        
        if user_b_option == 1 {
            otherSelectImage.image = UIImage(named: "scissors")
        }
        sendSelection()
    }
    
    @IBAction func pressRock(_ sender: UIButton) {
        mySelectImage.image = UIImage(named: "rock")
        user_a_option = 2
        user_b_option = 2
        
        if user_b_option == 2 {
            otherSelectImage.image = UIImage(named: "rock")
        }
        sendSelection()
    }
    
    @IBAction func pressPaper(_ sender: UIButton) {
        mySelectImage.image = UIImage(named: "paper")
        user_a_option = 3
        user_b_option = 3
        
        if user_b_option == 3 {
            otherSelectImage.image = UIImage(named: "paper")
        }
        sendSelection()
    }
    

}

extension ChaiViewController {
    
    func monitorRoomStatus() {
        
        if let url = URL(string: "https://85fb8eaa.ngrok.io/api/pss/watch/\(roomID)") {
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
                        self.myScoreLabel.text = "\(self.roomData?.data.records.user_a_score ?? 0)"
                        self.otherScoreLabel.text = "\(self.roomData?.data.records.user_b_score ?? 0)"
                        
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
        
        let passingData = GameOption(user_a_option: user_a_option!, user_b_option: user_b_option!)
        
        guard let uploadData = try? JSONEncoder().encode(passingData) else {
            return
        }
        let url = URL(string: "https://85fb8eaa.ngrok.io/api/pss/send/\(roomID)")!

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
}
