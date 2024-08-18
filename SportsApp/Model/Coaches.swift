//
//  Coaches.swift
//  SportsApp
//
//  Created by Marco on 2024-08-17.
//

import Foundation

struct Coaches: Codable{
    var coach_name : String
    var coach_country : String?
    var coach_age : String?
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        player_key = try container.decode(Int.self, forKey: .player_key)
//    }
    
    private enum CodingKeys: String, CodingKey {
            case coach_name
            case coach_country
            case coach_age
            
    }
}
