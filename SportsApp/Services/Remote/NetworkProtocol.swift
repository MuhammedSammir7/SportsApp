//
//  NetworkProtocol.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation

protocol NetworkProtocol{
    func getData<T>(path: String, sport: String, handler: @escaping (T) -> Void) where T : Decodable
    
    func getEvents(sport: String, league_key: Int, fromDate: String, toDate: String, handler: @escaping ([Events]?) -> Void)
    
    func getTeams(sport: String, league_key: Int?, team_key: Int?, fromDate: String?, toDate: String?, handler: @escaping ([Teams]?) -> Void)
}
