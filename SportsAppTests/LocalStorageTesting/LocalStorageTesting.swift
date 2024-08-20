//
//  LocalStorageTesting.swift
//  SportsAppTests
//
//  Created by ios on 20/08/2024.
//

import XCTest
import CoreData
@testable import SportsApp

class PersistenceManagerTests: XCTestCase {

    var persistenceManager: PersistenceManager!
    var mockManagedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        // Set up in-memory Core Data stack for testing
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        try persistentStoreCoordinator.addPersistentStore(
            ofType: NSInMemoryStoreType,
            configurationName: nil,
            at: nil,
            options: nil
        )
        
        mockManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mockManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        // Initialize the PersistenceManager with the mock context
        persistenceManager = PersistenceManager.shared
        persistenceManager.managedContext = mockManagedObjectContext
    }

    override func tearDownWithError() throws {
        persistenceManager = nil
        mockManagedObjectContext = nil
    }

    func testInsertLeague() throws {
        // Given
        let league = Leagues(league_key: 123, league_name: "Premier League", country_key: 1, country_name: "England", league_logo: nil, country_logo: nil)
        
        // When
        persistenceManager.insertLeague(leagu: league)
        
        // Then
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        let leagues = try mockManagedObjectContext.fetch(fetchRequest)
        
        XCTAssertEqual(leagues.count, 1)
        XCTAssertEqual(leagues.first?.value(forKey: "league_name") as? String, "Premier League")
    }

    func testCoreDataAttributeNames() {
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteLeague", in: persistenceManager.managedContext)
        XCTAssertNotNil(entity?.attributesByName["league_name"])
        XCTAssertNotNil(entity?.attributesByName["league_key"])
    }

    func testRemoveFromFavourites() throws {
        // Given
        let league = Leagues(league_key: 123, league_name: "Premier League", country_key: 1, country_name: "England", league_logo: nil, country_logo: nil)
        persistenceManager.insertLeague(leagu: league)
        
        // When
        persistenceManager.removeFromFavourites(leagueKey: 123)
        
        // Then
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        let leagues = try mockManagedObjectContext.fetch(fetchRequest)
        
        XCTAssertEqual(leagues.count, 0)
    }

    func testIsFavourited() throws {
        // Given
        let league = Leagues(league_key: 123, league_name: "Premier League", country_key: 1, country_name: "England", league_logo: nil, country_logo: nil)
        persistenceManager.insertLeague(leagu: league)
        
        // When
        let isFavourited = persistenceManager.isFavourited(leagueKey: 123)
        
        // Then
        XCTAssertTrue(isFavourited)
    }

    func testGetDataFromLocal() throws {
        // Given
        let league1 = Leagues(league_key: 123, league_name: "Premier League", country_key: 1, country_name: "England", league_logo: nil, country_logo: nil)
        let league2 = Leagues(league_key: 456, league_name: "La Liga", country_key: 2, country_name: "Spain", league_logo: nil, country_logo: nil)
        persistenceManager.insertLeague(leagu: league2)
        persistenceManager.insertLeague(leagu: league1)
        
        // When
        let leagues = persistenceManager.getDataFromLocal()
        
        // Then
        XCTAssertEqual(leagues.count, 2)
        XCTAssertEqual(leagues[0].league_name, "Premier League")
        XCTAssertEqual(leagues[1].league_name, "La Liga")
    }
}
