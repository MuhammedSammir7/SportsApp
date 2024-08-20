//
//  NetworkTests.swift
//  SportsAppTests
//
//  Created by Marco on 2024-08-20.
//

import XCTest

@testable import SportsApp

final class NetworkTests: XCTestCase {
    
    var network: Network?
    var league: Leagues?
    var sport: Sports?

    override func setUpWithError() throws {
        network = Network()
        league = Leagues(league_key: 159, league_name: "League 1", country_key: 4, country_name: "Egypt")
        sport = Sports(name: "football", image: "")
    }

    override func tearDownWithError() throws {
        network = nil
    }
    
    func testGetEventsSuccess() {
        // Given
        let expectation = self.expectation(description: "Events fetch succeeded")
        
        // When
        network?.getEvents(sport: "football", league_key: self.league!.league_key, fromDate: "2023-01-22", toDate: "2023-02-24", handler: { events in
            if events.isEmpty {
                XCTAssertEqual(events.count, 0)
                    expectation.fulfill()
                } else {
                    XCTAssertGreaterThan(events.count, 0)
                    expectation.fulfill()
                }
        })
        
        waitForExpectations(timeout: 2)
    }
    
    func testGetEventsFailier() {
        // Given
        let expectation = self.expectation(description: "Events fetch failed")
        
        // When
        network?.getEvents(sport: self.sport!.name, league_key: -1, fromDate: "2023-01-22", toDate: "2024-01-22", handler: { events in
            if events.isEmpty {
                XCTAssertEqual(events.count, 0)
                    expectation.fulfill()
                } else {
                    XCTAssertGreaterThan(events.count, 0)
                    expectation.fulfill()
                }
        })
        
        waitForExpectations(timeout: 1)
    }
    
    func testGetLeagueTeamsSuccess() {
        // Given
        let expectation = self.expectation(description: "League teams fetch succeeded")
        
        // When
        network?.getLeagueTeams(sport: self.sport!.name, league_key: self.league!.league_key, fromDate: "2023-01-22", toDate: "2024-01-22", handler: { teams in
                if teams.isEmpty {
                    XCTAssertEqual(teams.count, 0)
                    expectation.fulfill()
                } else {
                    XCTAssertGreaterThan(teams.count, 0)
                    expectation.fulfill()
                }
        })
        
        waitForExpectations(timeout: 2)
    }
    
    func testGetLeagueTeamsFailer() {
        // Given
        let expectation = self.expectation(description: "League teams fetch failier")
        
        // When
        network?.getLeagueTeams(sport: self.sport!.name, league_key: -1, fromDate: "2023-01-22", toDate: "2024-01-22", handler: { teams in
                if teams.isEmpty {
                    XCTAssertEqual(teams.count, 0)
                    expectation.fulfill()
                } else {
                    XCTAssertGreaterThan(teams.count, 0)
                    expectation.fulfill()
                }
        })
        
        waitForExpectations(timeout: 2)
    }
    
    func testGetTeamDetailsSuccess() {
        // Given
        let expectation = self.expectation(description: "League teams fetch succeeded")
        
        // When
        network?.getTeamDetails(sport: "football", team_key: 3, handler: { team in
                if team.isEmpty {
                    XCTAssertEqual(team.count, 0)
                    expectation.fulfill()
                } else {
                    XCTAssertGreaterThan(team.count, 0)
                    expectation.fulfill()
                }
        })
        
        waitForExpectations(timeout: 2)
    }
    
    func testGetTeamDetailsFailing() {
        // Given
        let expectation = self.expectation(description: "League teams fetch succeeded")
        
        // When
        network?.getTeamDetails(sport: "football", team_key: 0, handler: { team in
                if team.isEmpty {
                    XCTAssertEqual(team.count, 0)
                    expectation.fulfill()
                } else {
                    XCTAssertGreaterThan(team.count, 0)
                    expectation.fulfill()
                }
        })
        
        waitForExpectations(timeout: 1)
    }

}
