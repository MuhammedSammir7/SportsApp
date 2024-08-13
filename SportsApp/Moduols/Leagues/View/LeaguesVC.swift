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
        leagueViewModel = LeaguesViewModel(sport: sport, network: Network())

        leagueViewModel.bindResultToViewController = {
                    self.tableView.reloadData()
                    // Print the count here to ensure it reflects after data is fetched
           
                    print("arr count: \(self.leagueViewModel.leagues.count)")
                }
        leagueViewModel.getData()
        
        //handling swiping the screen
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        
    }
    // to dismiss the screen using swiper
    @objc func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension LeaguesVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueViewModel.leagues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell") as! LeaguesCell
//        cell.leagueNameLbl.text = leagueViewModel.leagues[indexPath.row].league_name
        guard indexPath.row < leagueViewModel.leagues.count else {
                    return cell
                }
                
                let selected = leagueViewModel.leagues[indexPath.row]
        cell.setCell(leagueName: selected.league_name, leagueImage: selected.league_logo ?? "default_logo")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let LeagueVC = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails")
        
        guard let vc = LeagueVC else {return}
        navigationController?.pushViewController(vc, animated: true)
    }
}
