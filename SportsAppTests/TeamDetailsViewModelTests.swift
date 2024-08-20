//
//  TeamDetailsViewModelTests.swift
//  SportsAppTests
//
//  Created by Marco on 2024-08-19.
//

import XCTest

@testable import SportsApp

final class TeamDetailsViewModelTests: XCTestCase {
    
    var teamDetailsVM : TeamDetailsViewModel?
    var team : Teams?
    
    override func setUpWithError() throws {
        teamDetailsVM = TeamDetailsViewModel(nwServic: Network(), sport: "football", team_key: 12, team_name: "Egypt")
        
        team = Teams(team_key: 155, team_name: "Tottenham")
        
    }
    
    func testTeamsDidSet() {
        // Given
        let expectation = self.expectation(description: "bindResult was called for team")
        
        teamDetailsVM?.bindResultToViewController = {
                expectation.fulfill()
        }
        // When
        teamDetailsVM?.team = [team!]
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testTeamDetails() {
        // Given
        let expectation = self.expectation(description: "team is set")
        
        teamDetailsVM?.bindResultToViewController = {
            expectation.fulfill()
        }
        // When
        teamDetailsVM?.getTeamDetails()
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }

    override func tearDownWithError() throws {
        teamDetailsVM = nil
        team = nil
    }

}
