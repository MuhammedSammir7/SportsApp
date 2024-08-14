//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation
import Alamofire

class LeagueDetailsViewModel {
    
    let sport : String
    let league_Key : Int
    var bindResultToViewController: (() -> Void) = {}
    
    var upcomingEvents: [Events]? {
        didSet {
            bindResultToViewController()
        }
    }
    var latestEvents: [Events]? {
        didSet {
            bindResultToViewController()
        }
    }
    var LeagueTeams: [Teams]? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init (sport: String, league: Int) {
        self.sport = sport
        self.league_Key = league
        getLeagueDetails()
    }
    
    func getLeagueDetails() {
        getUpComingEvents { [weak self] events in
            self?.upcomingEvents = events
        }
        getLatestEvents { [weak self] events in
            self?.latestEvents = events
        }
        getLeagueTeams { [weak self] teams in
            self?.LeagueTeams = teams
        }
        
    }
    
    func getFormattedDates() -> (beginnigDate: String, endingDate: String, currentDate: String){
        // Current Date
        let calendar = Calendar.current
        
        let beginingDate = calendar.date(byAdding: .year, value: -1, to: Date())
        let endingDate = calendar.date(byAdding: .year, value: 1, to: Date())
        let currentDate = calendar.date(byAdding: .year, value: 0, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let formattedCurrentDate = currentDate.flatMap { formatter.string(from: $0) }
        let formattedBeginnigDate = beginingDate.flatMap { formatter.string(from: $0) }
        let formattedEndingDate = endingDate.flatMap { formatter.string(from: $0) }
        
        return (formattedBeginnigDate!, formattedEndingDate!, formattedCurrentDate!)
    }
    
    func getUpComingEvents(handler: @escaping ([Events]?) -> Void) {
        
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = self.sport
        let league_key = self.league_Key
        let fromDate = getFormattedDates().currentDate
        let toDate = getFormattedDates().endingDate
        
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
    
    func getLatestEvents(handler: @escaping ([Events]?) -> Void) {
        
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = self.sport
        let league_key = self.league_Key
        let fromDate = getFormattedDates().beginnigDate
        let toDate = getFormattedDates().currentDate
        
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
    
    func getLeagueTeams(handler: @escaping ([Teams]?) -> Void) {
        
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = self.sport
        let league_key = self.league_Key
        let fromDate = getFormattedDates().beginnigDate
        let toDate = getFormattedDates().endingDate
        
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
                    //handler(leagueTeamsResponse.result)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
}
