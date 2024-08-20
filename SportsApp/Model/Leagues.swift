//
//  Leagues.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import Foundation

struct Leagues: Decodable{
    var league_key : Int
    var league_name : String
    var country_key : Int
    var country_name : String
    var league_logo : String?
    var country_logo : String?
}
