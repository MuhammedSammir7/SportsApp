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
    var events: [Events]? {
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
        getData { [weak self] events in
            self?.events = events
        }
    }
    
    func getBeginningAndEndingDate() -> (String, String){
        // Current Date
        let calendar = Calendar.current
        
        let beginingDate = calendar.date(byAdding: .year, value: -1, to: Date())
        let endingDate = calendar.date(byAdding: .year, value: 0, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let formattedBeginnigDate = beginingDate.flatMap { formatter.string(from: $0) }
        let formattedEndingDate = endingDate.flatMap { formatter.string(from: $0) }
        
        return (formattedBeginnigDate!, formattedEndingDate!)
    }
    
    func getData(handler: @escaping ([Events]?) -> Void) {
        
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = self.sport
        let league_key = self.league_Key
        let fromDate = getBeginningAndEndingDate().0
        let toDate = getBeginningAndEndingDate().1
        
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
    
//    func getlatestEvents(handler: @escaping ([Events]?) -> Void) {
//        
//        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
//        let sport = self.sport
//        let league_key = self.league_Key
//        let fromDate = getBeginningAndEndingDate().0
//        let toDate = getBeginningAndEndingDate().1
//        
//        // Current Date
//        let calendar = Calendar.current
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        
//        let formattedCurrentDate = calendar.date(byAdding: .year, value: 0, to: Date()).flatMap { formatter.string(from: $0) }!
//
//        let url = "https://apiv2.allsportsapi.com/\(sport)?met=Fixtures&leagueId=\(league_key)&from=\(fromDate)&to=\(formattedCurrentDate)&APIkey=\(apiKey)"
//        
//        AF.request(url, method: .get).responseDecodable(of: leagueEventsResponse.self) { response in
//                switch response.result {
//                case .success(let leagueEventsResponse):
//
//                    print("Fetched \(leagueEventsResponse.result.count) Events:")
//    
//                    handler(leagueEventsResponse.result)
//                    
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
//    }
}
