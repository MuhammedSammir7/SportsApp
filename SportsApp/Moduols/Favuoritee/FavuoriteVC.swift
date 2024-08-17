//
//  FavuoriteVC.swift
//  SportsApp
//
//  Created by ios on 14/08/2024.
//

import UIKit

class FavuoriteVC: UIViewController {

    var isFavuorite : Bool?
    var leagueViewModel : LeaguesViewModel!
    var favuoriteModel : FavuoriteViewModel!
    var sport : String?
    
    @IBOutlet weak var favuoriteLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        favuoriteLbl.text = "Favourite Leagues"
        favuoriteModel = FavuoriteViewModel()
        favuoriteModel.bindResultToViewController = {
            self.tableView.reloadData()
        }
        favuoriteModel.getData()
        
        
        
        
        if isFavuorite == false {
            favuoriteLbl.text = ""
            leagueViewModel = LeaguesViewModel(sport: sport, network: Network())

            leagueViewModel.bindResultToViewController = {
                        self.tableView.reloadData()
                    }
            leagueViewModel.getData()
            }
    }
    

}
extension FavuoriteVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavuorite == false{
            return leagueViewModel.leagues.count
        }
        return favuoriteModel.favuoriteLeagues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell") as! LeaguesCell
        if isFavuorite == false{
            let selected = leagueViewModel.leagues[indexPath.row]
            cell.setCell(leagueName: selected.league_name, leagueImage: selected.league_logo ?? "no-image")
        }else{
            let selected = favuoriteModel.favuoriteLeagues[indexPath.row]
            cell.setCell(leagueName: selected.league_name, leagueImage: selected.league_logo ?? "no-image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let LeagueVC = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails") as! LeagueDetailsViewController
        
        LeagueVC.viewModel = LeagueDetailsViewModel(sport: leagueViewModel.sport ?? "", league: leagueViewModel.leagues[indexPath.row].league_key)
        
        navigationController?.pushViewController(LeagueVC, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { action, view, completionHandler in
            self.favuoriteModel.favuoriteLeagues.remove(at: indexPath.row)
            // call the delete function and pass the index to it to delete from the coreData
            self.favuoriteModel.deleteLeague(index: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
