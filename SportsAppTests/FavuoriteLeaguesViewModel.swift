//
//  FavuoriteLeaguesViewModel.swift
//  SportsAppTests
//
//  Created by ios on 20/08/2024.
//

import XCTest
@testable import SportsApp

final class FavuoriteViewModelTests: XCTestCase {

    var favuoriteViewModel: FavuoriteViewModel?
    let leagues = [
        Leagues(league_key: 1, league_name: "Premier League", country_key: 230, country_name: "England"),
        Leagues(league_key: 2, league_name: "La Liga", country_key: 210, country_name: "Spain")
    ]
    
    override func setUpWithError() throws {
        favuoriteViewModel = FavuoriteViewModel()
        favuoriteViewModel?.bindResultToViewController = { [weak self] in
            // Can be used to set up expectations or validation after binding
        }
    }

    override func tearDownWithError() throws {
        favuoriteViewModel = nil
    }

    func testGetData() {
        favuoriteViewModel?.getData()
        
        XCTAssertEqual(favuoriteViewModel?.favuoriteLeagues.count, 6)
        XCTAssertEqual(favuoriteViewModel?.favuoriteLeagues.first?.league_name, "UEFA Champions League")
    }

    func testDeleteLeague() {
        // Given
        favuoriteViewModel?.getData() // Populate initial data
        let expectation = self.expectation(description: "League should be deleted and binding should be triggered")
        
        // Set up binding to fulfill expectation
        favuoriteViewModel?.bindResultToViewController = {
            expectation.fulfill()
        }
        
        // When
        favuoriteViewModel?.deleteLeague(index: 2)
        
        // Wait for the expectation
        waitForExpectations(timeout: 3.0, handler: nil)

        // Then
        XCTAssertEqual(favuoriteViewModel?.favuoriteLeagues.count, 6)
        XCTAssertFalse(favuoriteViewModel?.favuoriteLeagues.contains(where: { $0.league_key == 2 }) ?? true, "League with key 2 should have been deleted")
    }
}
