//
//  LeaguesViewModel.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import Foundation

class LeaguesViewModel {
    var sport: String?
    var network: NetworkProtocol!
    var bindResultToViewController: (() -> Void) = {}
    
    // Initialize leagues with an empty array to prevent nil errors
    var leagues: [Leagues] = [] {
        didSet {
            bindResultToViewController()
        }
    }
    
    init(sport: String?, network: NetworkProtocol!) {
        self.sport = sport
        self.network = network
    }
    
    func getData() {
        network.getData(path: "Leagues", sport: sport ?? "") { [weak self] (leagueResponse: LeaguesResponse?) in
            self?.leagues = leagueResponse?.result ?? []
        }
    }
}
