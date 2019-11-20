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
    }
    
    @IBAction func pressRock(_ sender: UIButton) {
        mySelectImage.image = UIImage(named: "rock")
    }
    
    @IBAction func pressPaper(_ sender: UIButton) {
        mySelectImage.image = UIImage(named: "paper")
    }
    

}

extension ChaiViewController {
    
    func monitorRoomStatus() {
        
        if let url = URL(string: "https://85fb8eaa.ngrok.io/api/pss/watch/1") {
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
    
    func sendYourSelection() {
        
    }
    
    
}
