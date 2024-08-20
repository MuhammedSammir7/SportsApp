//
//  NetworkProtocol.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation

protocol NetworkProtocol{
    func getData<T>(path: String, sport: String, handler: @escaping (T?) -> Void) where T : Decodable
    
    func getEvents(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([Events]?) -> Void)
    
    func getLeagueTeams(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([LeagueTeams]?) -> Void)
    
    func getTeamDetails(sport: String, team_key: Int, handler: @escaping ([Teams]) -> Void)
}
