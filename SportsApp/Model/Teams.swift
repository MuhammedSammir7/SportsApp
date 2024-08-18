//
//  teams2.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

struct Teams : Codable{
    var team_key : Int
    var team_name : String
    var team_logo : String?
    var players : [Players]?
    var coaches : [Coaches]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        team_key = try container.decode(Int.self, forKey: .team_key)
        team_name = try container.decode(String.self, forKey: .team_name)
        team_logo = try container.decode(String.self, forKey: .team_logo)
        players = try container.decode([Players].self, forKey: .players)
        coaches = try container.decode([Coaches].self, forKey: .coaches)
    }
    
    private enum CodingKeys: String, CodingKey {
            case team_key
            case team_name
            case team_logo
            case players
            case coaches
    }
}
