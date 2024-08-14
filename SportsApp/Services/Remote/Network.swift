//
//  Network.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation
import Alamofire
class Network: NetworkProtocol{
    var urlManager: URLManagerProtocol
        
        init(urlManager: URLManagerProtocol = URLManager()) {
            self.urlManager = urlManager
        }
    
    func getData<T>(path: String, sport: String, handler: @escaping (T) -> Void) where T : Decodable{
        
        guard let url = urlManager.setUrl(sport: sport, path: path) else {
                    print("Error: Invalid URL")
                    return
                }
        
        AF.request(url, method: .get).responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Raw JSON Response: \(jsonString)")
                        }
                        
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            handler(decodedData)
                        } catch let decodingError {
                            print("Error decoding data: \(decodingError)")
                        }
                        
                    case .failure(let error):
                        print("Error fetching data: \(error)")
                    }
                }
    }
    
    func getEvents(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([Events]?) -> Void) {
        
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = sport
        let league_key = league_key
        let fromDate = fromDate
        let toDate = toDate
        
        let url = "https://apiv2.allsportsapi.com/\(sport)?met=Fixtures&leagueId=\(league_key)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        
        AF.request(url, method: .get).responseDecodable(of: leagueEventsResponse.self) { response in
                switch response.result {
                case .success(let leagueEventsResponse):

                    print("Fetched \(leagueEventsResponse.result.count) Events:")
    
                    handler(leagueEventsResponse.result)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    func getLeagueTeams(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([Teams]?) -> Void) {
        
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = sport
        let league_key = league_key
        let fromDate = fromDate
        let toDate = toDate
        
        let url = "https://apiv2.allsportsapi.com/\(sport)?met=Fixtures&leagueId=\(league_key)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        
        AF.request(url, method: .get).responseDecodable(of: leagueTeamsResponse.self) { response in
                switch response.result {
                case .success(let leagueTeamsResponse):

                    print("Fetched \(leagueTeamsResponse.result.count) Teams:")
                    
                    // To get distinct teams
                    let teamsSet = Set(leagueTeamsResponse.result)
                    print (teamsSet.count)
                    print (teamsSet)
                    
                    handler(Array(teamsSet))
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
