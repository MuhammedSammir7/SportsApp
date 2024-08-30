//
//  URLManger.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation

class URLManager : URLManagerProtocol{
    private let apiKey = "38dadf677bfc7acbb27326868803f875951a18ae0c68d5ec9cb74d889583852e"
    func setUrl(sport: String, path: String) -> URL? {
        let urlString = "https://apiv2.allsportsapi.com/\(sport)/?APIkey=\(apiKey)&met=\(path)"
        return URL(string: urlString)
    }
}
