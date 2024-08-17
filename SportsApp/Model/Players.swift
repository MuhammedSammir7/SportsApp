//
//  Players.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

struct Players: Codable, Hashable{
    var player_key : Int
    var player_image : String?
    var player_name : String
    var player_type : String
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        player_key = try container.decode(Int.self, forKey: .player_key)
//    }
    
    private enum CodingKeys: String, CodingKey {
            case player_key
            case player_image
            case player_name
            case player_type
    }
}
