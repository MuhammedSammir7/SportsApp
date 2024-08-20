//
//  FavuoriteVC.swift
//  SportsApp
//
//  Created by ios on 14/08/2024.
//

import UIKit
import Alamofire

class FavuoriteVC: UIViewController {

    var isFavuorite = true
    var leagueViewModel : LeaguesViewModel!
    var favuoriteModel : FavuoriteViewModel!
    var sport : String?
    let reachabilityManager = NetworkReachabilityManager()

    @IBOutlet weak var noDataImg: UIImageView!
    @IBOutlet weak var favuoriteLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        if isFavuorite == false {
            favuoriteLbl.text = "Leagues"
            leagueViewModel = LeaguesViewModel(sport: sport, network: Network())

            leagueViewModel.bindResultToViewController = {
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
            activityIndicator.startAnimating()
            leagueViewModel.getData()
        }else{
            favuoriteModel = FavuoriteViewModel()

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if (isFavuorite == true){
            
            favuoriteLbl.text = "Favourite Leagues"
            favuoriteModel.bindResultToViewController = {
                self.tableView.reloadData()
            }
            print("\n\n\(favuoriteModel.favuoriteLeagues.count)\n\n")
            favuoriteModel.favuoriteLeagues.removeAll()
            print("\n\n\(favuoriteModel.favuoriteLeagues.count)\n\n")

            favuoriteModel.getData()
            tableView.reloadData()

            
            print("\n\n\(favuoriteModel.favuoriteLeagues.count)\n\n")

            
            if favuoriteModel.favuoriteLeagues.count == 0 {
                tableView.isHidden = true
            }else{
                tableView.isHidden = false
            }
            
            LeaguesCell.makingAction = {
                let alert = UIAlertController(title: "No Video!", message: "This league has no video.", preferredStyle: .alert)
                 let ok = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }

        }
    }
    

}
extension FavuoriteVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavuorite == false{
            return leagueViewModel.leagues.count
        }else{
            return favuoriteModel.favuoriteLeagues.count
        }}
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
        guard reachabilityManager?.isReachable == true else {
            showNoConnectionAlert()
            return
        }
        
        if isFavuorite == false {
            let LeagueVC = self.storyboard?.instantiateViewController(withIdentifier: "NewLeagueDetails") as! NewLeagueDetailsViewController
            
            LeagueVC.viewModel = LeagueDetailsViewModel(nwServic: Network(), sport: leagueViewModel.sport ?? "", league: leagueViewModel.leagues[indexPath.row])
            
            present(LeagueVC, animated: true)
        }else {
            let leagueVC = self.storyboard?.instantiateViewController(withIdentifier: "NewLeagueDetails") as! NewLeagueDetailsViewController
            
            let selected = favuoriteModel.favuoriteLeagues[indexPath.row]
            
            leagueVC.viewModel = LeagueDetailsViewModel(nwServic: Network(), sport: "football", league: selected)
            
            present(leagueVC, animated: true)
        }}
        
        // checking connection alert
    func showNoConnectionAlert() {
            let alert = UIAlertController(title: "No Connection", message: "You need an internet connection to view league details.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)}
        
      
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if isFavuorite{
            let delete = UIContextualAction(style: .destructive, title: "delete") { action, view, completionHandler in
                let alert = UIAlertController(title: "delete", message: "Are you sure you want to delete this league?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .destructive) { action in
                    self.favuoriteModel.deleteLeague(index: self.favuoriteModel.favuoriteLeagues[indexPath.row].league_key)
                    self.favuoriteModel.favuoriteLeagues.remove(at: indexPath.row)
                    if self.favuoriteModel.favuoriteLeagues.count == 0 {
                        tableView.isHidden = true
                    }else{
                        tableView.isHidden = false
                    }
                    self.tableView.reloadData()
                    
                    completionHandler(true)
                }
                let cancle = UIAlertAction(title: "Cancle", style: .cancel)
                alert.addAction(yes)
                alert.addAction(cancle)
                self.present(alert, animated: true)
                
            }
            return UISwipeActionsConfiguration(actions: [delete])
        }
        return nil
    }
    }

