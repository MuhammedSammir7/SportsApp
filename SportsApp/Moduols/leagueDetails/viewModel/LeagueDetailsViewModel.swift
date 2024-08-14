//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation
import Alamofire

class LeagueDetailsViewModel {
    
    let league_Key : Int
    var bindResultToViewController: (() -> Void) = {}
    var events: [Events]? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init (league: Int) {
        self.league_Key = league
        getLeagueDetails()
    }
    
    func getLeagueDetails() {
        getData { [weak self] events in
            self?.events = events
        }
    }
    
    func getData(handler: @escaping ([Events]?) -> Void) {
        
        let url = "https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=205&from=2023-01-18&to=2024-01-18&APIkey=1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
//        let url = "https://apiv2.allsportsapi.com/football/?APIkey=1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403&met=Leagues"
        
        AF.request(url, method: .get).responseDecodable(of: leagueEventsResponse.self) { response in
                switch response.result {
                case .success(let leagueEventsResponse):
                    // Use the decoded posts array
                    print("Fetched \(leagueEventsResponse.result.count) Events:")
//                    for event in leagueEventsResponse.result {
//                        print("Post \(event.event_key): \(event.event_date)")
//                    }
    
                    handler(leagueEventsResponse.result)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
