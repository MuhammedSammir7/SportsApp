//
//  TeamDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation
import Alamofire

class TeamDetailsViewModel {
    
    let nwServic : NetworkProtocol
    let sport : String
    let team_key : Int
    let team_name: String
    var bindResultToViewController: (() -> Void) = {}
    
    var team : [Teams2]? {
        didSet {
            print(self.team?.first?.team_name ?? "sss" )
            bindResultToViewController()
        }
    }
    
    init(nwServic: NetworkProtocol, sport: String, team_key: Int, team_name: String) {
        self.nwServic = nwServic
        self.sport = sport
        self.team_key = team_key
        self.team_name = team_name
        getTeamDetails()
    }
    
    func getTeamDetails() {
        getTeam(sport: self.sport, league_key: nil, team_key: self.team_key, fromDate: nil, toDate: nil) { team in
        self.team = team
        }
    }
    
    func getTeam(sport: String, league_key: Int?, team_key: Int?, fromDate: String?, toDate: String?, handler: @escaping ([Teams2]) -> Void) {
        
        let apiKey = "1d1ff13cb74815bcfc1b274dbeddfb5c6813a19f743dade1cd76743e9172b403"
        let sport = sport
        let league_key = league_key
        let fromDate = fromDate
        let toDate = toDate
        var url = ""
        
        if let league_key = league_key {
           url = "https://apiv2.allsportsapi.com/\(sport)?met=Fixtures&leagueId=\(league_key)&from=\(fromDate!)&to=\(toDate!)&APIkey=\(apiKey)"
        } else {
            url = "https://apiv2.allsportsapi.com/\(sport)/?met=Teams&teamId=\(team_key!)&APIkey=\(apiKey)"
        }
        
        AF.request(url, method: .get).responseDecodable(of: TeamResponse.self) { response in
                switch response.result {
                case .success(let teamResponse):

                    print("Fetched \(teamResponse.result.count) Team")
                    
                    handler(teamResponse.result)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    
}
