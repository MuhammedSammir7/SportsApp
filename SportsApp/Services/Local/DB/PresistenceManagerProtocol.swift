//
//  PresistenceManagerProtocol.swift
//  SportsApp
//
//  Created by ios on 17/08/2024.
//

import Foundation

protocol FavuoriteDBProtocol {
    func insertLeague(leagu: Leagues)
    func getDataFromLocal() -> [Leagues]
    func removeFromFavourites(leagueKey: Int)
}
