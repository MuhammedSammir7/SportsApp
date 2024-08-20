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
    var league : Leagues?
    var event : Events?
    var team : LeagueTeams?

    override func setUpWithError() throws {
        LeagueDetailsVM = LeagueDetailsViewModel(nwServic: Network(), sport: "football", league: Leagues(league_key: 1, league_name: "My League", country_key: 20, country_name: "Egypt"))
        
        league = Leagues(league_key: 1, league_name: "League 1", country_key: 4, country_name: "Egypt")
        
        event = Events(event_key: 1, event_date: "2025-05-18", event_time: "14:30", home_team_key: 20, event_home_team: "Home team", away_team_key: 15, event_away_team: "Away Team", event_final_result: "3 - 0", league_name: "League 1", league_season: "2025/ / 2024", event_stadium: "", event_ft_result: "3 - 0")
        
        team = LeagueTeams(home_team_key: 1, event_home_team: "Zamalek")
    }
    
    func testUpcomingEventsDidSet() {
        // Given
        let expectation = self.expectation(description: "bindResult was called")
        LeagueDetailsVM?.bindResultToViewController = {
                expectation.fulfill()
        }
        // When
        LeagueDetailsVM?.upcomingEvents = [event!]
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    func testLatestEventsDidSet() {
        // Given
        let expectation = self.expectation(description: "bindResult was called")
        LeagueDetailsVM?.bindResultToViewController = {
                expectation.fulfill()
        }
        // When
        LeagueDetailsVM?.latestEvents = [event!]
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    func testTeamsDidSet() {
        // Given
        let expectation = self.expectation(description: "bindResult was called")
        LeagueDetailsVM?.bindResultToViewController = {
                expectation.fulfill()
        }
        // When
        LeagueDetailsVM?.LeagueTeams = [team!]
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
//    func testGetLeagueDetails() {
//        let expectation = self.expectation(description: "Got League Data")
//        
//        LeagueDetailsVM?.bindResultToViewController = {
//            
//                expectation.fulfill()
//        
//        }
//        
//        LeagueDetailsVM?.getLeagueDetails()
//        
//        waitForExpectations(timeout: 2, handler: nil)
//    }
    
    func testAddToFavourite() {
        LeagueDetailsVM?.addToFavourites()
    }
    
    func testRemoveFromFavourite() {
        LeagueDetailsVM?.removeFromFavourites()
    }

    override func tearDownWithError() throws {
        LeagueDetailsVM = nil
        league = nil
        event = nil
        team = nil
    }

}
