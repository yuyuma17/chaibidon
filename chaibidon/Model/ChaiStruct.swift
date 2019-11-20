//
//  ChaiStruct.swift
//  chaibidon
//
//  Created by 黃士軒 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import Foundation

// 基礎格式
struct Foundation: Codable {
    
    let id: Int?
    let round_id: Int?
    let user_a_id: String?
    let user_a_name: String?
    let user_a_option: String?
    let user_a_score: Int?
    let user_b_id: String?
    let user_b_name: String?
    let user_b_option: String?
    let user_b_score: Int?
    let end: Int?
    let created_at: String?
    let updated_at: String?
    
}

//以下登入用
struct YourName: Codable {
    
    let name: String
    
}

//以下接收登入後回傳資訊
struct LoginAndReceiveData: Codable {
    
    let room: Foundation
    let status: String
    
}

//以下監聽用
struct DataFoundation: Codable {
    
    let game_name: String
    let records: Foundation
    
}

struct RoomData: Codable {
    
    let data: DataFoundation
    
}

//以下送剪刀石頭布答案
struct GameOption: Codable {
    
    let user_name: String
    let user_option: Int
    
}
