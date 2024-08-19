//
//  LeagueDetailsViewModelTests.swift
//  SportsAppTests
//
//  Created by Marco on 2024-08-19.
//

import XCTest

@testable import SportsApp

final class LeagueDetailsViewModelTests: XCTestCase {
    
    var LeagueDetailsVM : LeagueDetailsViewModel?
    var event : Events?

    override func setUpWithError() throws {
        LeagueDetailsVM = LeagueDetailsViewModel(nwServic: Network(), sport: "football", league: Leagues(league_key: 1, league_name: "My League", country_key: 20, country_name: "Egypt"))
        
//        event = Events(event_key: 1, event_date: "2025-05-18", event_time: "14:30", home_team_key: 20, event_home_team: "Home team", away_team_key: 15, event_away_team: "Away Team", event_final_result: "3 - 0", league_name: "League 1", league_season: "2025/ / 2024", event_stadium: "")
    }
    
    func testUpcomingEventsDidSet() {
        LeagueDetailsVM?.upcomingEvents = []
    }

    override func tearDownWithError() throws {
        LeagueDetailsVM = nil
    }

}
