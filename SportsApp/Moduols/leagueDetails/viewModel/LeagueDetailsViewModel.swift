//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

class LeagueDetailsViewModel {
    
    let nwServic : NetworkProtocol
    
    let sport : String
    let league_Key : Int
    let league_name : String
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
    
    init (nwServic: NetworkProtocol,sport: String, league_key: Int, league_name: String) {
        self.nwServic = nwServic
        self.sport = sport
        self.league_Key = league_key
        self.league_name = league_name
        getLeagueDetails()
    }
    
    func getLeagueDetails() {
        // UpComing
        nwServic.getEvents(sport: self.sport, league_key: self.league_Key, fromDate: getFormattedDates().currentDate, toDate: getFormattedDates().endingDate) { [weak self] events in
            print((events?.count)!)
            self?.upcomingEvents = events
        }
        // Latest
        nwServic.getEvents(sport: self.sport, league_key: self.league_Key, fromDate: getFormattedDates().beginnigDate, toDate: getFormattedDates().currentDate) { [weak self] events in
            self?.latestEvents = events
        }
        // Teams
        nwServic.getTeams(sport: self.sport, league_key: self.league_Key, team_key: nil, fromDate: getFormattedDates().beginnigDate, toDate: getFormattedDates().endingDate) { [weak self] teams in
            self?.LeagueTeams = teams
        }
    }
    
    func getFormattedDates() -> (beginnigDate: String, endingDate: String, currentDate: String){
        // Current Date
        let calendar = Calendar.current
        
        let beginingDate = calendar.date(byAdding: .year, value: -1, to: Date())
        let endingDate = calendar.date(byAdding: .year, value: 1, to: Date())
        let currentDate = calendar.date(byAdding: .day, value: -1, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let formattedCurrentDate = currentDate.flatMap { formatter.string(from: $0) }
        let formattedBeginnigDate = beginingDate.flatMap { formatter.string(from: $0) }
        let formattedEndingDate = endingDate.flatMap { formatter.string(from: $0) }
        
        return (formattedBeginnigDate!, formattedEndingDate!, formattedCurrentDate!)
    }
    
}
