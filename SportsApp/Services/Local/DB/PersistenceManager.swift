//
//  PersistenceManager.swift
//  SportsApp
//
//  Created by ios on 14/08/2024.
//

import UIKit
import CoreData

class PersistenceManager{
   // var context: NSManagedObjectContext!
   // var entity: NSEntityDescription!
    var managedContext: NSManagedObjectContext
    var leaguesL: [Leagues] = []
    static let shared = PersistenceManager()
    
    private init(){
//        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        entity = NSEntityDescription.entity(forEntityName: "FavouriteLeague", in: context)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
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
    func getDataFromLocal() -> [Leagues]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        do{
            let leagues = try managedContext.fetch(fetchRequest)
            for league in leagues{
                let l = Leagues(league_key: league.value(forKey: "league_key") as! Int, league_name: league.value(forKey: "league_name") as! String, country_key: league.value(forKey: "country_key") as! Int, country_name: league.value(forKey: "country_name") as! String , league_logo: league.value(forKey: "league_logo") as? String , country_logo: league.value(forKey: "country_logo") as? String )
                leaguesL.append(l)
            }
            print("\nGetting all leagues done...\n")
        }catch let error as NSError{
            print("\nerror in fetching all leagues: \(error)\n")
        }
        
        return leaguesL
    }
    func getSpecificLeague(name: String,key: Int) -> Leagues?{
        var leagueL: Leagues?
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        
        let myPredicate = NSPredicate(format: "name == %@ and key == %d", name, key)
        fetchRequest.predicate = myPredicate
        do{
            let leagues = try managedContext.fetch(fetchRequest)
            if leagues.count > 0{
                let league = leagues[key]
                let l = Leagues(league_key: league.value(forKey: "league_key") as! Int, league_name: league.value(forKey: "league_name") as! String, country_key: league.value(forKey: "country_key") as! Int, country_name: league.value(forKey: "country_name") as! String , league_logo: league.value(forKey: "league_logo") as? String , country_logo: league.value(forKey: "country_logo") as? String )
                print("\nGetting league done...\n")
            }else{
                print("no such itemmmmmmå")
            }
        }catch let error as NSError{
            print("\nerror in fetching all leagues: \(error)\n")
        }
        
        return leagueL ?? nil
    }
    func deleteFromLeagues(key: Int) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        
        //let myPredicate = NSPredicate(format: "key == %d", key)
        //        let myPredicate = NSPredicate(format: "name == %@ and key == %d", name, key)
       // fetchRequest.predicate = myPredicate
        do{
            let leagues = try managedContext.fetch(fetchRequest)
            print(leagues.count)
            if leagues.count > 0{
                managedContext.delete(leagues[key])
                try managedContext.save()
                
                print("\nDelete league done...\n")
            }
        }catch let error as NSError{
            print("\nerror in deleteting a league : \(error)\n")
        }
    
    }
    
}
//sport: i.value(forKey: "sport") as! String,
