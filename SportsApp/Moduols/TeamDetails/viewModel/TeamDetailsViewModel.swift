//
//  TeamDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

class TeamDetailsViewModel {
    
    let nwServic : NetworkProtocol
    
    let sport : String
    let team_key : Int
    let team_name: String
    var bindResultToViewController: (() -> Void) = {}
    
    var team : [Teams]? {
        didSet {
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
        nwServic.getTeamDetails(sport: self.sport, team_key: self.team_key) { team in
        self.team = team
        }
    }
    
}
