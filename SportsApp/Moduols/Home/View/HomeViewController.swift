//
//  ViewController.swift
//  SportsApp
//
//  Created by ios on 11/08/2024.
//

import UIKit
import Network
class HomeViewController: UIViewController {
    
    let monitor = NWPathMonitor()
    var isConnected: Bool = false
    @IBOutlet weak var collectionView: UICollectionView!
    let sports = [Sports(name: "Football", image: "football"),
                  Sports(name: "Basketball", image: "basketBall"),
                  Sports(name: "Cricket", image: "cricket"),
                  Sports(name: "Tennis", image: "tennis")]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }


}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sports.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportCell", for: indexPath) as! SportsCell
        cell.sportName.text = sports[indexPath.row].name
        cell.sportImage.image = UIImage(named: sports[indexPath.row].image) 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.49, height: self.view.frame.height * 0.15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        monitor.pathUpdateHandler = { path in
                self.isConnected = (path.status == .satisfied)
                    DispatchQueue.main.async {
                        if self.isConnected {
                            //  is online
                            //Data from Api
                            if let leagueVC = self.storyboard?.instantiateViewController(identifier: "LeaguesVC") as? LeaguesVC{
                                leagueVC.sport = self.sports[indexPath.row].name.lowercased()
                                self.navigationController?.pushViewController(leagueVC, animated: true)
                            }
                                
                            
                        } else {
                            //  is offline
                            /*Data from coreData to the favuorite and no data in the sports view
                            And an alert for the user shows him that there is no data or a photo
                            And if the user wanted to open somthing from favuorite stop him with an alert tells him that there is no connection.
                             */
                            let alert = UIAlertController(title: "No Connection!", message: "Cheack your internet connection and try again.", preferredStyle: .alert)
                            let cancle = UIAlertAction(title: "Cancle", style: .cancel,handler: nil)
//                            let tryAgain = UIAlertAction(title: "Try again", style: .default) { action in
//                                <#code#>
//                            }
                            alert.addAction(cancle)
                            self.present(alert, animated: true)
                        }
                    }
                }
                
                let queue = DispatchQueue(label: "NetworkMonitor")
                monitor.start(queue: queue)
    }

}
