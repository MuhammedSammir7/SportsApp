//
//  Network.swift
//  SportsApp
//
//  Created by ios on 12/08/2024.
//

import Foundation
import Alamofire
class Network: NetworkProtocol{
    var urlManager : URLManagerProtocol
    init() {
        self.urlManager = URLManager()
    }
    func getData<T>(path: String, sport: String, handler: @escaping (T) -> Void) where T : Decodable{
        urlManager = URLManager()
        
        AF.request(urlManager.setUrl(sport: sport, path: path)!, method: .get).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let data):
                print("done")
                handler(data)
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
}
