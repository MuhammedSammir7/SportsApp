//
//  Network.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation
import Alamofire
class Network: NetworkProtocol{
    var urlManager: URLManagerProtocol
        
        init(urlManager: URLManagerProtocol = URLManager()) {
            self.urlManager = urlManager
        }
    
    func getData<T>(path: String, sport: String, handler: @escaping (T) -> Void) where T : Decodable{
        
        guard let url = urlManager.setUrl(sport: sport, path: path) else {
                    print("Error: Invalid URL")
                    return
                }
        
        AF.request(url, method: .get).responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Raw JSON Response: \(jsonString)")
                        }
                        
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            handler(decodedData)
                        } catch let decodingError {
                            print("Error decoding data: \(decodingError)")
                        }
                        
                    case .failure(let error):
                        print("Error fetching data: \(error)")
                    }
                }
    }
}
