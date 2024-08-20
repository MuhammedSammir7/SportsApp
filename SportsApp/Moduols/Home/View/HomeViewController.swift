//
//  ViewController.swift
//  SportsApp
//
//  Created by ios on 11/08/2024.
//

import UIKit
import Alamofire
class HomeViewController: UIViewController {
    let viewModel = SportsViewModel()
    let reachabilityManager = NetworkReachabilityManager()
        var isConnected: Bool {
            return reachabilityManager?.isReachable ?? true
        }

    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        reachabilityManager?.startListening(onUpdatePerforming: { [self] status in
                    switch status {
                    case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                        print("Network is reachable")
                        collectionView.isHidden = false
                        //uncomment this
                        //ImageView.isHidden = true
                        if presentedViewController is UIAlertController {
                            dismiss(animated: true)
                        }
                    case .notReachable:
                        print("Network is not reachable")
//                        let alert = UIAlertController(title: "No Connection!", message: "Cheack your internet connection and try again.", preferredStyle: .alert)
//                        let cancle = UIAlertAction(title: "Cancle", style: .cancel,handler: nil)
//                        let tryAgain = UIAlertAction(title: "Try Again", style: .default) { action in
//                            
//                                print("Network is Not reachable")
//                                self.present(alert, animated: true)
//                            
//                            
//                            }
//                        alert.addAction(cancle)
//                        alert.addAction(tryAgain)
//                        self.present(alert, animated: true)
                        collectionView.isHidden = true
                        //uncomment this
                        //ImageView.isHidden = false
                    case .unknown:
                        print("Network status is unknown")
                    }
                })
    }

}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sports.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportCell", for: indexPath) as! SportsCell
        cell.sportName.text = viewModel.sports[indexPath.row].name
        cell.sportImage.image = UIImage(named: viewModel.sports[indexPath.row].image)
        
        cell.sportImage.layer.cornerRadius = min(cell.frame.width, cell.frame.height) / 8
        cell.sportImage.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.5, height: self.view.frame.height * 0.15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        let leagueVC = self.storyboard?.instantiateViewController(identifier: "FavuoriteVC") as? FavuoriteVC
        if let leagueViewController = leagueVC{
            leagueViewController.sport = self.viewModel.sports[indexPath.row].name.lowercased()
            leagueViewController.isFavuorite = false
            self.tabBarController?.navigationController?.pushViewController(leagueViewController, animated: true)
            
        }
        
                                
                            
//                        } else {
//                            //  is offline
//                            /*Data from coreData to the favuorite and no data in the sports view
//                            And an alert for the user shows him that there is no data or a photo
//                            And if the user wanted to open somthing from favuorite stop him with an alert tells him that there is no connection.
//                             */
//                            let alert = UIAlertController(title: "No Connection!", message: "Cheack your internet connection and try again.", preferredStyle: .alert)
//                            let cancle = UIAlertAction(title: "Cancle", style: .cancel,handler: nil)
////                            let tryAgain = UIAlertAction(title: "Try again", style: .default) { action in
////                                <#code#>
////                            }
//                            alert.addAction(cancle)
//                            self.present(alert, animated: true)
//                        }
                }
            
    }

