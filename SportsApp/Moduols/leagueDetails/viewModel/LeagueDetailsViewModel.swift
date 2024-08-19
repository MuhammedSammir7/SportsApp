//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

class LeagueDetailsViewModel {
    
    let nwServic : NetworkProtocol
    
    let league : Leagues
    
    
    let sport : String
    
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
    var LeagueTeams: [LeagueTeams]? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init (nwServic: NetworkProtocol,sport: String, league: Leagues) {
        self.nwServic = nwServic
        self.sport = sport
        self.league = league
        getLeagueDetails()
        let favourites = PersistenceManager.shared.getDataFromLocal()
        let favouriteLeague = favourites.filter {$0.league_key == self.league.league_key}
//        if !(favouriteLeague.isEmpty) {self.isFavoutite = true}
    }
    
    func getLeagueDetails() {
        // UpComing
        nwServic.getEvents(sport: self.sport, league_key: self.league.league_key, fromDate: getFormattedDates().currentDate, toDate: getFormattedDates().endingDate) { [weak self] events in
            self?.upcomingEvents = events
        }
        // Latest
        nwServic.getEvents(sport: self.sport, league_key: self.league.league_key, fromDate: getFormattedDates().beginnigDate, toDate: getFormattedDates().currentDate) { [weak self] events in
            self?.latestEvents = events
        }
        // Teams
        nwServic.getLeagueTeams(sport: self.sport, league_key: self.league.league_key, fromDate: getFormattedDates().beginnigDate, toDate: getFormattedDates().endingDate) { [weak self] teams in
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
    func insertLeague(){
        PersistenceManager.shared.insertLeague(leagu: self.league)
    }
    func deleteLeague(){
        PersistenceManager.shared.removeFromFavourites(leagueKey: self.league.league_key)
    }
}
