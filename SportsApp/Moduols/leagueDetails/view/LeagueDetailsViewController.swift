//
//  LeagueDetailsViewController.swift
//  SportsApp
//
//  Created by Marco on 2024-08-11.
//

import UIKit
import Kingfisher

class LeagueDetailsViewController: UICollectionViewController {
    
    var viewModel : LeagueDetailsViewModel?
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        viewModel?.bindResultToViewController = {
            self.indicator.stopAnimating()
            self.collectionView.reloadData()
        }
        
        self.title = viewModel?.league_name
        
        let cellNib = UINib(nibName: "UpComingCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "UpComingCell")
        
        let layout = UICollectionViewCompositionalLayout { indexPath, enviroment in
            
            switch indexPath{
            case 0:
                return self.drawSection(groupWidth: 1, groupHeight: 250, isScrollingHorizontally: true)
            case 1:
                return self.drawSection(groupWidth: 1, groupHeight: 132, isScrollingHorizontally: false)
            case 2:
                return self.drawSection(groupWidth: 0.2, groupHeight: 78, isScrollingHorizontally: true)
            default:
                return self.drawSection(groupWidth: 1, groupHeight: 1, isScrollingHorizontally: false)
            }
            
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    @IBAction func addOrRemoveFromFavourites(_ sender: Any) {
        if favouriteButton.image == UIImage(systemName: "heart") {
            favouriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favouriteButton.image = UIImage(systemName: "heart")
        }
    }
    
    func drawHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(60.0))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
        
        return header
    }
    
    func drawSection(groupWidth: CGFloat, groupHeight: CGFloat, isScrollingHorizontally: Bool) -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth), heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        
        if isScrollingHorizontally {
            section.orthogonalScrollingBehavior = .continuous
        }
        
        section.boundarySupplementaryItems = [drawHeader()]

        return section
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCell", for: indexPath) as! SectionHeaderCollectionViewCell
        
        switch indexPath.section {
        case 0:
            sectionHeaderView.SectionHeaderLabel.text = "UpComing"
        case 1:
            sectionHeaderView.SectionHeaderLabel.text = "Latest Fixtures"
        case 2:
            sectionHeaderView.SectionHeaderLabel.text = "Teams"
        default:
            break
        }
        
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // Adjust height as needed
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if viewModel?.upcomingEvents?.count ?? 10 < 10 {
                return viewModel?.upcomingEvents?.count ?? 0
            } else {
                return 10
            }
        case 1:
            if viewModel?.latestEvents?.count ?? 10 < 10 {
                return viewModel?.latestEvents?.count ?? 0
            } else {
                return 10
            }
        case 2:
            if viewModel?.LeagueTeams?.count ?? 20 < 30 {
                return viewModel?.LeagueTeams?.count ?? 0
            } else {
                return 30
            }
        default:
            return 10
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
            
            
            if let teams = viewModel?.LeagueTeams {
                cell.teamImage.kf.setImage(with: URL(string: teams[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: "no-image"))
                cell.layer.isHidden = false
            } else {
                cell.layer.isHidden = true
            }
            
            cell.layer.cornerRadius = cell.frame.width / 2
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 2.0
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingCell", for: indexPath) as! UpComingCollectionViewCell
        
        switch indexPath.section{
        case 0:
            
            if let events = viewModel?.upcomingEvents {
                cell.HomeTeamImage.kf.setImage(with: URL(string: events[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: "no-image"))
                
                cell.AwayTeamImage.kf.setImage(with: URL(string: events[indexPath.row].away_team_logo ?? "") , placeholder: UIImage(named: "no-image"))
                
                cell.eventName.text = events[indexPath.row].league_name
                cell.dateLabel.text = events[indexPath.row].event_date
                cell.timeLabel.text = events[indexPath.row].event_time
                
                cell.layer.isHidden = false
            } else {
                cell.layer.isHidden = true
            }
            
            cell.eventName.font = cell.eventName.font.withSize(18)
            cell.eventName.textColor = UIColor.white
            cell.dateLabel.font = cell.dateLabel.font.withSize(16)
            cell.dateLabel.textColor = UIColor.white
            cell.timeLabel.font = cell.timeLabel.font.withSize(16)
            cell.timeLabel.textColor = UIColor.white
            
            cell.scoreSeparator.isHidden = true
            cell.homeScore.isHidden = true
            cell.awayScore.isHidden = true
            
            cell.vsImage.isHidden = false
            cell.backgoundImage.isHidden = false
        case 1:
            if let events = viewModel?.latestEvents {
                cell.HomeTeamImage.kf.setImage(with: URL(string: events[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: "no-image"))
                
                cell.AwayTeamImage.kf.setImage(with: URL(string: events[indexPath.row].away_team_logo ?? "") , placeholder: UIImage(named: "no-image"))
                
                cell.eventName.text = events[indexPath.row].league_name
                cell.dateLabel.text = events[indexPath.row].event_date
                cell.timeLabel.text = events[indexPath.row].event_time
                
                cell.homeScore.text = String((events[indexPath.row].event_final_result).prefix(1))
                cell.awayScore.text = String((events[indexPath.row].event_final_result).suffix(1))
                
                cell.layer.isHidden = false
            } else {
                cell.layer.isHidden = true
            }
            
            cell.eventName.font = cell.eventName.font.withSize(16)
            cell.eventName.textColor = UIColor.darkGray
            cell.dateLabel.font = cell.dateLabel.font.withSize(14)
            cell.dateLabel.textColor = UIColor.darkGray
            cell.timeLabel.font = cell.timeLabel.font.withSize(14)
            cell.timeLabel.textColor = UIColor.darkGray
            
            cell.scoreSeparator.isHidden = false
            cell.homeScore.isHidden = false
            cell.awayScore.isHidden = false
            
            cell.vsImage.isHidden = true
            cell.backgoundImage.isHidden = true
        default:
            cell.backgoundImage.isHidden = false
            
        }
        cell.layer.cornerRadius = cell.frame.width / 8
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 5.0

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let teamDetailsVC = storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamDetailsCollectionViewController
            
            teamDetailsVC.viewModel = TeamDetailsViewModel(nwServic: Network(), sport: viewModel!.sport, team_key: (viewModel?.LeagueTeams![indexPath.row].home_team_key)!, team_name: (viewModel?.LeagueTeams![indexPath.row].event_home_team)!)
            navigationController?.pushViewController(teamDetailsVC, animated: true)
        }
    }

}
