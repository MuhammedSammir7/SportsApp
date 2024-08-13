//
//  LeaguesViewModel.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import Foundation

class LeaguesViewModel{
    var sprot : String?
    var network : NetworkProtocol!
    var bindResultToViewController : (()->()) = {}
    // Array that you will pass to the viewController
    var leagues: [Leagues]!
    
    init(sprot: String?, network: NetworkProtocol!) {
        self.sprot = sprot
        self.network = network
    }
    
    func getData() {
        network.getData(path: "Leagues", sport: sprot ?? "") {[weak self] (LeagueResponse : LeaguesResponse!) in
            self?.leagues = LeagueResponse.result
            self?.bindResultToViewController()
        }
    }
}

