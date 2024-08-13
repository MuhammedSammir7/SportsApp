//
//  Responses.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import Foundation

struct LeaguesResponse: Decodable {
    let success: Int
    let result: [Leagues]
}
