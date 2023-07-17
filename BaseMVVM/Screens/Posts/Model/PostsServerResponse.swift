//
//  PostsServerResponse.swift
//  BaseMVVM
//
//  Created by Thulani Mtetwa on 2023/07/16.
//

import Foundation

struct PostServerResponse: Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


typealias Posts = [PostServerResponse]
