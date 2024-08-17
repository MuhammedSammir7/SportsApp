//
//  PresistenceManagerProtocol.swift
//  SportsApp
//
//  Created by ios on 17/08/2024.
//

import Foundation

protocol FavuoriteDBProtocol {
    static func insertLeague(leagu: Leagues)
    static func getDataFromLocal() -> [Leagues]
    static func getSpecificLeague(name: String,key: Int) -> Leagues?
    static func deleteFromLeagues(key: Int)
}
