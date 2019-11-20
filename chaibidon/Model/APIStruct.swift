//
//  APIStruct.swift
//  chaibidon
//
//  Created by 陳姿穎 on 2019/11/20.
//  Copyright © 2019 Lacie. All rights reserved.
//

import Foundation

struct BiWait: Codable {
    
    var data: Int
    
}

struct Leave: Codable {
    
    var id: Int
    
}


struct BiAnswer: Codable {
    
    var name: String
    var answer: Int
    
}

struct BiResult: Codable {
    
    var data: Data
    
    struct Data: Codable {
        
        var winner: String
        var compares: [Compares]
        
        struct Compares: Codable {
            
            var name: String
            var answer: Int?
            
        }
        
    }
    
    
}
