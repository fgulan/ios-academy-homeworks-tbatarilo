//
//  Shows.swift
//  TVShow
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import Foundation

struct Show: Codable {
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}
