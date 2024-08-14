//
//  Events.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

struct Events: Codable {
    var event_key : Int
    var event_date : String
//    var event_time : Int
//    var home_team_key : Int
//    var event_home_team : Int
    var home_team_logo : String?
//    var away_team_key : Int
//    var event_away_team : Int
    var away_team_logo : String?
//    var event_final_result : String
//    var league_name : String
//    var league_season : String
//    var event_stadium : String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event_key = try container.decode(Int.self, forKey: .event_key)
        event_date = try container.decode(String.self, forKey: .event_date)
        home_team_logo = try container.decode(String.self, forKey: .home_team_logo)
        away_team_logo = try container.decode(String.self, forKey: .away_team_logo)
    }
    
    private enum CodingKeys: String, CodingKey {
            case event_key
            case event_date
            case home_team_logo
            case away_team_logo
    }
}
