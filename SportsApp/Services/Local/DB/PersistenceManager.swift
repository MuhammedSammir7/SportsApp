//
//  PersistenceManager.swift
//  SportsApp
//
//  Created by ios on 14/08/2024.
//

import UIKit
import CoreData

class PersistenceManager{
   
    var managedContext: NSManagedObjectContext!

    
    static let shared = PersistenceManager()
    
    private init(){
        managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    }
    func insertLeague(leagu: Leagues){
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteLeague", in: managedContext)
        let league = NSManagedObject(entity: entity!, insertInto: managedContext)
        league.setValue(leagu.league_name, forKey: "league_name")
        league.setValue(leagu.league_key, forKey: "league_key")
        league.setValue(leagu.country_name, forKey: "country_name")
        league.setValue(leagu.league_logo, forKey: "league_logo")
        league.setValue(leagu.country_logo, forKey: "country_logo")
        league.setValue(leagu.country_key, forKey: "country_key")
        do{
            try managedContext.save()
            print("\nInserting a league done...\n")
        }catch let error as NSError{
            print("\nerror in adding to favourite: \(error)\n")
        }
    }
     

    func removeFromFavourites(leagueKey: Int) {
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
       let storedFavourites = try? self.managedContext.fetch(fetchRequest)
       
       guard let favourites = storedFavourites else {
           return
       }
       for league in favourites {
           if league.value(forKey: "league_key") as! Int == leagueKey {
               managedContext.delete(league)
           }
       }
           do {
               try managedContext.save()
               print("Deleted!!")
           } catch let error as NSError {
               print("Can't Delete a League!")
               print(error.localizedDescription)
           }
       }
    func isFavourited(leagueKey: Int ) -> Bool{
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
            fetchRequest.predicate = NSPredicate(format: "league_key == %d", leagueKey)
            
            do {
                let favourites = try managedContext.fetch(fetchRequest)
                return !favourites.isEmpty
               } catch {
                   print("Failed to fetch favourites: \(error.localizedDescription)")
                   return false
               }
           }
    func getDataFromLocal() -> [Leagues] {
        // Ensure the array is empty before populating it
        var leaguesL: [Leagues] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        
        do {
            let leagues = try managedContext.fetch(fetchRequest)
            
            for league in leagues {
                // Safely unwrap the values
                let leagueKey = league.value(forKey: "league_key") as? Int ?? 0
                let leagueName = league.value(forKey: "league_name") as? String ?? "Unknown"
                let countryKey = league.value(forKey: "country_key") as? Int ?? 0
                let countryName = league.value(forKey: "country_name") as? String ?? "Unknown"
                let leagueLogo = league.value(forKey: "league_logo") as? String
                let countryLogo = league.value(forKey: "country_logo") as? String
                
                let l = Leagues(
                    league_key: leagueKey,
                    league_name: leagueName,
                    country_key: countryKey,
                    country_name: countryName,
                    league_logo: leagueLogo,
                    country_logo: countryLogo
                )
                leaguesL.append(l)
            }
            
            print("\nGetting all leagues done...\n")
        } catch let error as NSError {
            print("\nError in fetching all leagues: \(error)\n")
        }
        
        return leaguesL
    }
}
//sport: i.value(forKey: "sport") as! String,
