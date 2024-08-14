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
    var event_time : String
    var home_team_key : Int
    var event_home_team : String
    var home_team_logo : String?
    var away_team_key : Int
    var event_away_team : String
    var away_team_logo : String?
    var event_final_result : String
    var league_name : String
    var league_season : String
    var event_stadium : String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event_key = try container.decode(Int.self, forKey: .event_key)
        event_date = try container.decode(String.self, forKey: .event_date)
        home_team_logo = try container.decode(String.self, forKey: .home_team_logo)
        away_team_logo = try container.decode(String.self, forKey: .away_team_logo)
        event_time = try container.decode(String.self, forKey: .event_time)
        home_team_key = try container.decode(Int.self, forKey: .home_team_key)
        event_home_team = try container.decode(String.self, forKey: .event_home_team)
        away_team_key = try container.decode(Int.self, forKey: .away_team_key)
        event_away_team = try container.decode(String.self, forKey: .event_away_team)
        event_final_result = try container.decode(String.self, forKey: .event_final_result)
        league_name = try container.decode(String.self, forKey: .league_name)
        league_season = try container.decode(String.self, forKey: .league_season)
        event_stadium = try container.decode(String.self, forKey: .event_stadium)
    }
    
    private enum CodingKeys: String, CodingKey {
            case event_key
            case event_date
            case home_team_logo
            case away_team_logo
            case event_time
            case home_team_key
            case event_home_team
            case away_team_key
            case event_away_team
            case event_final_result
            case league_name
            case league_season
            case event_stadium
        
    }
}
