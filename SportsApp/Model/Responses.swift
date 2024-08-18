//
//  Responses.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import Foundation

struct LeaguesResponse: Decodable {
    let result: [Leagues]
}

struct leagueEventsResponse : Decodable {
    let result: [Events]
}

struct leagueTeamsResponse : Decodable, Hashable {
    let result: [LeagueTeams]
}

struct TeamResponse : Decodable {
    let result: [Teams]
}

struct TeamResponse : Decodable {
    let result: [Teams2]
}

