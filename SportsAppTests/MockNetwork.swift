//
//  MockNetwork.swift
//  SportsAppTests
//
//  Created by ios on 20/08/2024.
//

import Foundation
@testable import SportsApp

class MockNetwork: NetworkProtocol {
    var shouldReturnError = false
    var leaguesResponse: LeaguesResponse?
    var eventsResponse: [Events]?
        var leagueTeamsResponse: [LeagueTeams]?
        var teamDetailsResponse: [Teams]?
        
    func getData<T>(path: String, sport: String, handler: @escaping (T?) -> Void) where T : Decodable {
        if shouldReturnError {
            handler( nil )
        } else {
            handler((leaguesResponse as? T)!)
        }
    
    }
    
    func getEvents(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([Events]) -> Void) {
            if shouldReturnError {
                handler([])
            } else {
                handler(eventsResponse ?? [])
            }
        }
        
        func getLeagueTeams(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([LeagueTeams]) -> Void) {
            if shouldReturnError {
                handler([])
            } else {
                handler(leagueTeamsResponse ?? [])
            }
        }
        
        func getTeamDetails(sport: String, team_key: Int, handler: @escaping ([Teams]) -> Void) {
            if shouldReturnError {
                handler([])
            } else {
                handler(teamDetailsResponse ?? [])
            }
        }
    
}
