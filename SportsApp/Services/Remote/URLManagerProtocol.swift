//
//  URLManagerProtocol.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import Foundation

protocol URLManagerProtocol {
    func setUrl(sport: String, path: String)-> URL?
}
