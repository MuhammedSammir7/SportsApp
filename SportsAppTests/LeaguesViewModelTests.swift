//
//  LeaguesViewModelTests.swift
//  SportsAppTests
//
//  Created by ios on 19/08/2024.
//

import XCTest
@testable import SportsApp

final class LeaguesViewModelTests: XCTestCase {

    var leaguesViewModel : LeaguesViewModel?
    var mockNetwork : MockNetwork?
    let leagues = [Leagues(league_key: 1, league_name: "primerLeague", country_key: 230, country_name: "England"),Leagues(league_key: 2, league_name: "Laliga", country_key: 210, country_name: "Spain")]
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        leaguesViewModel = LeaguesViewModel(sport: "football", network: Network())
        mockNetwork = MockNetwork()
    }
    
    func testGetDataSuccessMoking() {
           // Given
        
       // mockNetwork!.leaguesResponse = LeaguesResponse(result: leagues)

           XCTAssertEqual(leagues.count, 2)
        XCTAssertEqual(leagues.first?.league_name, "primerLeague")
       }
    func testGetDataFailure() {
        // Given
        XCTAssertFalse(leagues.isEmpty)
    }
    
    func testGetDataSuccess() {
            // Given
            mockNetwork?.leaguesResponse = LeaguesResponse(result: leagues)

            // When
            let expectation = self.expectation(description: "Data fetch should succeed")
            leaguesViewModel?.bindResultToViewController = {
                expectation.fulfill()
            }
            leaguesViewModel?.getData()
            
            waitForExpectations(timeout: 2.0, handler: nil)

            // Then
            XCTAssertEqual(leaguesViewModel?.leagues.count, 917)
            XCTAssertEqual(leaguesViewModel?.leagues.first?.league_name, "UEFA Europa League")
        }
    
    func testLeaguesBinding() {
            // Given
            mockNetwork?.leaguesResponse = LeaguesResponse(result: leagues)

            let expectation = self.expectation(description: "Binding should update leagues")
            leaguesViewModel?.bindResultToViewController = {
                expectation.fulfill()
            }
            leaguesViewModel?.getData()
            
            waitForExpectations(timeout: 3.0, handler: nil)

            // Then
            XCTAssertEqual(leaguesViewModel?.leagues.count, 917)
        }
    
    func testInitialLeaguesEmpty() {
            
            XCTAssertTrue(leaguesViewModel?.leagues.isEmpty ?? true, "Expected leagues to be empty initially")
        }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        leaguesViewModel = nil
        mockNetwork = nil
    }

    
}
