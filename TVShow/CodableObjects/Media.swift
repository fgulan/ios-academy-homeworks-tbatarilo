//
//  Media.swift
//  TVShow
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import Foundation

struct Media: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
