//
//  Teams.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

struct LeagueTeams: Codable, Hashable {
    var home_team_key : Int
    var event_home_team : String
    var home_team_logo : String?

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        home_team_logo = try container.decode(String.self, forKey: .home_team_logo)
//        home_team_key = try container.decode(Int.self, forKey: .home_team_key)
//        event_home_team = try container.decode(String.self, forKey: .event_home_team)
//        players = try container.decode([Players].self, forKey: .players)
//    }
    
    private enum CodingKeys: String, CodingKey {
            case home_team_logo
            case home_team_key
            case event_home_team
    }
}
