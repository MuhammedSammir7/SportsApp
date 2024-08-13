//
//  NetworkProtocol.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation

protocol NetworkProtocol{
    func getData<T>(path: String, sport: String, handler: @escaping (T) -> Void) where T : Decodable
}
