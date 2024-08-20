//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

class LeagueDetailsViewModel {
    
    let nwServic : NetworkProtocol
    let dbServic : PersistenceManager = PersistenceManager.shared
    
    let league : Leagues
    var isFavoutite : Bool = false
    
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
        let favourites = dbServic.getDataFromLocal()
        let favouriteLeague = favourites.filter {$0.league_key == self.league.league_key}
        if !(favouriteLeague.isEmpty) {self.isFavoutite = true}
    }
    
    func getLeagueDetails() {
        // UpComing
        nwServic.getEvents(sport: self.sport, league_key: self.league.league_key, fromDate: getFormattedDates().currentDatePluse, toDate: getFormattedDates().endingDate) { [weak self] events in
            
            var newEvents = events
            newEvents.sort{ (self?.getFormattedDates(dateSting: $0.event_date).eventDate)!  < (self?.getFormattedDates(dateSting: $1.event_date).eventDate)!}
            
            self?.upcomingEvents = newEvents
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
    
    func getFormattedDates(dateSting: String? = nil) -> (beginnigDate: String, endingDate: String, currentDatePluse: String, currentDate: String, eventDate: Date?){
        // Current Date
        let calendar = Calendar.current
        
        let beginingDate = calendar.date(byAdding: .year, value: -1, to: Date())
        let endingDate = calendar.date(byAdding: .year, value: 1, to: Date())
        let currentDate = calendar.date(byAdding: .hour, value: 0, to: Date())
        let currentDatePluse = calendar.date(byAdding: .hour, value: 3, to: Date())
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var eventDate : Date? = nil
        if let dateSting = dateSting {eventDate = formatter.date(from: dateSting)}
        
        let formattedCurrentDatePluse = currentDatePluse.flatMap { formatter.string(from: $0) }
        let formattedCurrentDate = currentDate.flatMap { formatter.string(from: $0) }
        let formattedBeginnigDate = beginingDate.flatMap { formatter.string(from: $0) }
        let formattedEndingDate = endingDate.flatMap { formatter.string(from: $0) }
        
        return (formattedBeginnigDate!, formattedEndingDate!, formattedCurrentDatePluse!, formattedCurrentDate!, eventDate)
    }
    
    func addToFavourites() {
        dbServic.insertLeague(leagu: self.league)
    }
    
    func removeFromFavourites() {
        dbServic.removeFromFavourites(leagueKey: self.league.league_key)
    }
}
