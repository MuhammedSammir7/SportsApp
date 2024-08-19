//
//  NewLeagueDetailsViewController.swift
//  SportsApp
//
//  Created by Marco on 2024-08-19.
//

import UIKit

class NewLeagueDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var leagueTitle: UILabel!
    var viewModel : LeagueDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel?.bindResultToViewController = {
            self.collectionView.reloadData()
        }
        
        self.leagueTitle.text = viewModel?.league.league_name
        
        setFavouriteButton()
        
        if (viewModel?.isFavoutite)! {
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        let cellNib = UINib(nibName: "UpComingCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "UpComingCell")
        
        let notFoundCellNib = UINib(nibName: "NotFoundCollectionViewCell", bundle: nil)
        collectionView.register(notFoundCellNib, forCellWithReuseIdentifier: "notFoundCell")
        
        let loadingCellNib = UINib(nibName: "LoadingCollectionViewCell", bundle: nil)
        collectionView.register(loadingCellNib, forCellWithReuseIdentifier: "loadingCell")
        
        let layout = UICollectionViewCompositionalLayout { [self] indexPath, enviroment in
            
            switch indexPath{
            case 0:
                return self.drawSection(groupWidth: 1, groupHeight: 250, isScrollingHorizontally: true)
            case 1:
                return self.drawSection(groupWidth: 1, groupHeight: 140, isScrollingHorizontally: false)
            case 2:
                return self.drawSection(groupWidth: viewModel?.LeagueTeams?.count == 0 ? 1 : 0.2, groupHeight: 78, isScrollingHorizontally: true)
            default:
                return self.drawSection(groupWidth: 1, groupHeight: 1, isScrollingHorizontally: false)
            }
            
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    

    @IBAction func addToFavourites(_ sender: Any) {
        if (viewModel?.isFavoutite)! {
            let alert = UIAlertController(title: "💔", message: "Remove from favourites !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "remove", style: .destructive, handler: { action in
                self.favouriteButton.imageView!.image = UIImage(systemName: "heart")
                self.viewModel?.removeFromFavourites()
                self.viewModel?.isFavoutite = false
                self.collectionView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            addPulsatingAnimation(to: favouriteButton)
            
            viewModel?.addToFavourites()
            viewModel?.isFavoutite = true
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCell", for: indexPath) as! SectionHeaderCollectionViewCell
        
        
        switch indexPath.section {
        case 0:
            sectionHeaderView.SectionHeaderLabel.text = "UpComing"
            return sectionHeaderView
        case 1:
            sectionHeaderView.SectionHeaderLabel.text = "Latest Fixtures"
            return sectionHeaderView
        case 2:
            sectionHeaderView.SectionHeaderLabel.text = "Teams"
            return sectionHeaderView
        default:
            return sectionHeaderView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // Adjust height as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if viewModel?.upcomingEvents?.count ?? 10 < 10 {
                return viewModel?.upcomingEvents?.count == 0 ? 1 : viewModel?.upcomingEvents?.count ?? 1
            } else {
                return 10
            }
        case 1:
            if viewModel?.latestEvents?.count ?? 10 < 10 {
                return viewModel?.latestEvents?.count == 0 ? 1 : viewModel?.latestEvents?.count ?? 1
            } else {
                return 10
            }
        case 2:
            if viewModel?.LeagueTeams?.count ?? 20 < 30 {
                return viewModel?.LeagueTeams?.count == 0 ? 1 : viewModel?.LeagueTeams?.count ?? 1
            } else {
                return 30
            }
        default:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let notFoundCell = collectionView.dequeueReusableCell(withReuseIdentifier: "notFoundCell", for: indexPath) as! NotFoundCollectionViewCell
        let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCollectionViewCell
        
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
            
            
            if let teams = viewModel?.LeagueTeams {
                
                if teams.isEmpty {
                    notFoundCell.message.text = "No teams available"
                    return notFoundCell
                }
                
                cell.teamImage.kf.setImage(with: URL(string: teams[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: "no-image"))
                cell.layer.isHidden = false
            } else {
                return loadingCell
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
                
                if events.isEmpty {
                    notFoundCell.message.text = "No Upcoming Events"
                    return notFoundCell
                }
                
                cell.HomeTeamImage.kf.setImage(with: URL(string: events[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: "no-image"))
                
                cell.AwayTeamImage.kf.setImage(with: URL(string: events[indexPath.row].away_team_logo ?? "") , placeholder: UIImage(named: "no-image"))
                
                cell.eventName.text = events[indexPath.row].league_name
                cell.dateLabel.text = events[indexPath.row].event_date
                cell.timeLabel.text = events[indexPath.row].event_time
                
                cell.layer.isHidden = false
            } else {
                return loadingCell
            }
            
            cell.homeTeamName.isHidden = true
            cell.awayTeamName.isHidden = true
            
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
                
                if events.isEmpty {
                    notFoundCell.message.text = "No Recent Events"
                    return notFoundCell
                }
                
                cell.HomeTeamImage.kf.setImage(with: URL(string: events[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: "no-image"))
                
                cell.AwayTeamImage.kf.setImage(with: URL(string: events[indexPath.row].away_team_logo ?? "") , placeholder: UIImage(named: "no-image"))
                
                cell.homeTeamName.text = events[indexPath.row].event_home_team
                cell.awayTeamName.text = events[indexPath.row].event_away_team
                cell.homeTeamName.isHidden = false
                cell.awayTeamName.isHidden = false
                
                cell.eventName.text = events[indexPath.row].league_name
                cell.dateLabel.text = events[indexPath.row].event_date
                cell.timeLabel.text = events[indexPath.row].event_time
                
                cell.homeScore.text = String((events[indexPath.row].event_final_result).prefix(1))
                cell.awayScore.text = String((events[indexPath.row].event_final_result).suffix(1))
                
                cell.layer.isHidden = false
            } else {
                return loadingCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let teamDetailsVC = storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamDetailsCollectionViewController
            
            teamDetailsVC.viewModel = TeamDetailsViewModel(nwServic: Network(), sport: viewModel!.sport, team_key: (viewModel?.LeagueTeams![indexPath.row].home_team_key)!, team_name: (viewModel?.LeagueTeams![indexPath.row].event_home_team)!)
            
            present(teamDetailsVC, animated: true)
        }
    }
    
    // Set favourite button
    func setFavouriteButton() {
        favouriteButton.layer.shadowColor = UIColor.red.cgColor
        favouriteButton.layer.shadowRadius = 0
        favouriteButton.layer.shadowOpacity = 0.8
        favouriteButton.layer.shadowOffset = CGSize.zero
        favouriteButton.layer.masksToBounds = false
    }
    
    // Add pulsating animation
    func addPulsatingAnimation(to view: UIView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.25
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .zero
        view.layer.add(pulseAnimation, forKey: "pulse")
        
        // Add animation to make the glow pulsate
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = 8
        glowAnimation.duration = 1.0
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .zero
        
        view.layer.add(glowAnimation, forKey: "glowAnimation")
    }
    
}
