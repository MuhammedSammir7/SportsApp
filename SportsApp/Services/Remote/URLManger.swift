//
//  URLManger.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation

class URLManager : URLManagerProtocol{
    private let apiKey = "290715401e75ed818b51f1db53e2c02269602b9b477fa4037f0b62fd1ed71fee"
    func setUrl(sport: String, path: String) -> URL? {
        let urlString = "https://apiv2.allsportsapi.com/\(sport)/?APIkey=\(apiKey)&met=\(path)"
        return URL(string: urlString)
    }
}
