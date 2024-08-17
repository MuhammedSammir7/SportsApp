//
//  FavuoriteeViewModel.swift
//  SportsApp
//
//  Created by ios on 17/08/2024.
//

import Foundation

class FavuoriteViewModel{
    var bindResultToViewController: (() -> Void) = {}
    var favuoriteLeagues : [Leagues] = [] {
        didSet {
            bindResultToViewController()
        }
    }
   
    func getData(){
        favuoriteLeagues = PersistenceManager.getDataFromLocal()
    }
    func deleteLeague(index: Int){
        PersistenceManager.deleteFromLeagues(key: index)
        bindResultToViewController()
    }
}
