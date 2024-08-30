//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Marco on 2024-08-14.
//

import Foundation

class LeagueDetailsViewModel {
    
    let nwServic : NetworkProtocol
    let dbService : PersistenceManager = PersistenceManager.shared
    
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
        let favourites = dbService.getDataFromLocal()
        let favouriteLeague = favourites.filter {$0.league_key == self.league.league_key}
        if !(favouriteLeague.isEmpty) {self.isFavoutite = true}
    }
    
    func getLeagueDetails() {
        // UpComing
        nwServic.getEvents(sport: self.sport, league_key: self.league.league_key, fromDate: getFormattedDates().currentDate, toDate: getFormattedDates().endingDate) { [weak self] events in
            
            // Sorting events
            var sortedEvents = events
            sortedEvents.sort{ (self?.getFormattedDates(dateSting: $0.event_date).eventDate)!  < (self?.getFormattedDates(dateSting: $1.event_date).eventDate)!}
            
            // Filtering Events
            let filterdEvents = self?.filterEvents(events: sortedEvents, isUpComing: true)
            
            self?.upcomingEvents = filterdEvents
        }
        // Latest
        nwServic.getEvents(sport: self.sport, league_key: self.league.league_key, fromDate: getFormattedDates().beginnigDate, toDate: getFormattedDates().currentDate) { [weak self] events in
            
            // Filtering Events
            let filterdEvents = self?.filterEvents(events: events, isUpComing: false)
            
            self?.latestEvents = filterdEvents
        }
        // Teams
        nwServic.getLeagueTeams(sport: self.sport, league_key: self.league.league_key, fromDate: getFormattedDates().beginnigDate, toDate: getFormattedDates().endingDate) { [weak self] teams in
            self?.LeagueTeams = teams
        }
    }
    
    func getFormattedDates(dateSting: String? = nil) -> (beginnigDate: String, endingDate: String, currentDate: String, eventDate: Date?){
        // Current Date
        let calendar = Calendar.current
        
        let beginingDate = calendar.date(byAdding: .year, value: -1, to: Date())
        let endingDate = calendar.date(byAdding: .year, value: 1, to: Date())
        let currentDate = calendar.date(byAdding: .day, value: 0, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var eventDate : Date? = nil
        if let dateSting = dateSting {eventDate = formatter.date(from: dateSting)}
        
        let formattedCurrentDate = currentDate.flatMap { formatter.string(from: $0) }
        let formattedBeginnigDate = beginingDate.flatMap { formatter.string(from: $0) }
        let formattedEndingDate = endingDate.flatMap { formatter.string(from: $0) }
        
        return (formattedBeginnigDate!, formattedEndingDate!, formattedCurrentDate!, eventDate)
    }
    
    func filterEvents(events: [Events], isUpComing: Bool) -> [Events] {
        // Filtering Events
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinute = Calendar.current.component(.minute, from: Date())
        
        let filterdEvents = events.filter { [weak self] event in
            if event.event_date == self?.getFormattedDates().currentDate{
                if let eventTime = formatter.date(from: event.event_time) {
                    
                    let eventHour = Calendar.current.component(.hour, from: eventTime)
                    let eventMinute = Calendar.current.component(.minute, from: eventTime)
                    
                    switch isUpComing{
                    case true:
                        if eventHour < currentHour {
                            return false
                        }
                    case false:
                        if eventHour + 1 >= currentHour  {
                            if eventHour + 1 == currentHour{
                                if eventMinute < currentMinute{return true}
                            }
                            return false
                        }
                    }
                }
            }
            return true
        }
        
        return filterdEvents
    }
    
    func addToFavourites() {
        dbService.insertLeague(leagu: self.league)
    }
    
    func removeFromFavourites() {
        dbService.removeFromFavourites(leagueKey: self.league.league_key)
    }
}
