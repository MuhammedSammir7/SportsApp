//
//  FavuoriteeViewModel.swift
//  SportsApp
//
//  Created by ios on 17/08/2024.
//

import Foundation

class FavuoriteViewModel{
    var bindResultToViewController: (() -> Void) = {}
    var favuoriteLeagues : [Leagues] = []
   
    func getData(){
        favuoriteLeagues = PersistenceManager.shared.getDataFromLocal()
    }
    func deleteLeague(index: Int){
        PersistenceManager.shared.removeFromFavourites(leagueKey: index)
        bindResultToViewController()
    }
}
