//
//  LeaguesVC.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import UIKit

class LeaguesVC: UIViewController {

    var leagueViewModel : LeaguesViewModel!
    var sport : String?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        leagueViewModel = LeaguesViewModel(sprot: sport, network: Network())
//        leagueViewModel.
        leagueViewModel.ArrayToViewController = {
            self.tableView.reloadData()
        }
    }
    

}

extension LeaguesVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueViewModel.leagues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell") as! LeaguesCell
//        cell.leagueNameLbl.text = leagueViewModel.leagues[indexPath.row].league_name
        let selected = leagueViewModel.leagues[indexPath.row]
        cell.setCell(leagueName: selected.league_name, leagueTitle: selected.league_logo)
        return cell
    }
}
