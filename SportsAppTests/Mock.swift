//
//  Mock.swift
//  SportsAppTests
//
//  Created by Marco on 2024-08-20.
//

import Foundation

@testable import SportsApp

class Mock: NetworkProtocol{
    var shouldReturnError: Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
//    let fakeJSONTeam : [String: Any] =
//    ["result":
//        [
//            [ "team_key": 1,
//              "team_name": "Türkiye",
//              "team_logo": "https://apiv2.allsportsapi.com/logo/1_turkiye.jpg" ]
//        ]
//    ]
    
    func getData<T>(path: String, sport: String, handler: @escaping (T) -> Void) where T : Decodable {
        //
    }
    
    func getEvents(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([SportsApp.Events]?) -> Void) {
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = sport
        let league_key = league_key
        let fromDate = fromDate
        let toDate = toDate
        
        let url = "https://apiv2.allsportsapi.com/\(sport)?met=Fixtures&leagueId=\(league_key)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        
//        AF.request(url, method: .get).responseDecodable(of: leagueEventsResponse.self) { response in
//                switch response.result {
//                case .success(let leagueEventsResponse):
//    
//                    handler(leagueEventsResponse.result)
//                    
//                case .failure(let error):
//                    print("Error: \(error)")
                    handler([])
                //}
//            }
    }
    
    func getLeagueTeams(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([SportsApp.LeagueTeams]?) -> Void) {
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = sport
        let league_key = league_key
        let fromDate = fromDate
        let toDate = toDate
        let url = "https://apiv2.allsportsapi.com/\(sport)?met=Fixtures&leagueId=\(league_key)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        
//        AF.request(url, method: .get).responseDecodable(of: leagueTeamsResponse.self) { response in
//                switch response.result {
//                case .success(let leagueTeamsResponse):
//                    
//                    // To get distinct teams
//                    let teamsSet = Set(leagueTeamsResponse.result)
//                    
//                    let uniqueTeams = teamsSet.reduce(into: [LeagueTeams]()) { result, team in
//                        if !result.contains(where: { $0.home_team_key == team.home_team_key }) {
//                            result.append(team)
//                        }
//                    }

//                    handler(uniqueTeams)
                    
//                case .failure(let error):
//                    print("Error: \(error)")
                    handler([])
//                }
//            }
    }
    
    func getTeamDetails(sport: String, team_key: Int, handler: @escaping ([SportsApp.Teams]) -> Void) {
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = sport
        let team_key = team_key
        
        let url = "https://apiv2.allsportsapi.com/\(sport)/?met=Teams&teamId=\(team_key)&APIkey=\(apiKey)"
        
//        AF.request(url, method: .get).responseDecodable(of: TeamResponse.self) { response in
//                switch response.result {
//                case .success(let teamResponse):
//
//                    handler(teamResponse.result)
//                    
//                case .failure(let error):
//                    print("Error: \(error)")
                    handler([])
//                }
//            }
    }
    
    
}
