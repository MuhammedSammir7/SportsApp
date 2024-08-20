//
//  TeamDetailsCollectionViewController.swift
//  SportsApp
//
//  Created by Marco on 2024-08-12.
//

import UIKit
import Kingfisher

class TeamDetailsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var viewModel : TeamDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.bindResultToViewController = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        let notFoundCellNib = UINib(nibName: "NotFoundCollectionViewCell", bundle: nil)
        collectionView.register(notFoundCellNib, forCellWithReuseIdentifier: "notFoundCell")
        
        let loadingCellNib = UINib(nibName: "LoadingCollectionViewCell", bundle: nil)
        collectionView.register(loadingCellNib, forCellWithReuseIdentifier: "loadingCell")
        
        self.title = self.viewModel?.team_name
        
        let layout = UICollectionViewCompositionalLayout { indexPath, enviroment in
            
            switch indexPath{
            case 0:
                return self.drawSection(groupWidth: 1, groupHeight: 300, leading: 0 , trailing: 0, headerHeight: 60, isScrollingHorizontally: false)
            case 1:
                return self.drawSection(groupWidth: 1, groupHeight: 150, leading: 10 , trailing: 10, headerHeight: 0.1, isScrollingHorizontally: false)
            case 2:
                return self.drawSection(groupWidth: 1, groupHeight: 110, leading: 10 , trailing: 10, headerHeight: 60, isScrollingHorizontally: false)
            default:
                return self.drawSection(groupWidth: 1, groupHeight: 300, leading: 0 , trailing: 0, headerHeight: 0.1, isScrollingHorizontally: true)
            }
            
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
    }

    func drawHeader(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem{
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(height))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
        
        return header
    }
    
    func drawSection(groupWidth: CGFloat, groupHeight: CGFloat, leading: CGFloat, trailing: CGFloat, headerHeight: CGFloat, isScrollingHorizontally: Bool) -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth), heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: leading, bottom: 10, trailing: trailing)
        let section = NSCollectionLayoutSection(group: group)
        
        if isScrollingHorizontally {
            section.orthogonalScrollingBehavior = .continuous
        }
        
        section.boundarySupplementaryItems = [drawHeader(height: headerHeight)]

        return section
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TeamViewSectionHeaderCell", for: indexPath) as! SectionHeaderCollectionViewCell
        
        switch indexPath.section {
        case 0:
            sectionHeaderView.SectionHeaderLabel.isHidden = false
            sectionHeaderView.SectionHeaderLabel.text = viewModel?.team_name
            sectionHeaderView.SectionHeaderLabel.textAlignment = .center
        case 1:
            sectionHeaderView.SectionHeaderLabel.isHidden = true
        case 2:
            sectionHeaderView.SectionHeaderLabel.isHidden = false
            sectionHeaderView.SectionHeaderLabel.textAlignment = .left
            sectionHeaderView.SectionHeaderLabel.text = "Players"
        default:
            break
        }
        
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            switch section{
            case 0:
                return CGSize(width: collectionView.frame.width, height: 0) // Adjust height as needed
            default:
                return CGSize(width: collectionView.frame.width, height: 50) // Adjust height as needed
        }
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let team = viewModel?.team  else {return 1}
        
        return team.isEmpty ? 1 : 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.viewModel?.team?.first?.players?.count ?? 0
        default:
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        // Configure the cell
        let notFoundCell = collectionView.dequeueReusableCell(withReuseIdentifier: "notFoundCell", for: indexPath) as! NotFoundCollectionViewCell
        let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCollectionViewCell
        
        if !(viewModel?.reachabilityManager?.isReachable)! {
            notFoundCell.message.text = "No Network Connection 🛜"
            return notFoundCell
        } else if viewModel?.team == nil {
            return loadingCell
        } else if (viewModel?.team)!.isEmpty {
            notFoundCell.message.text = "No Team Details Found"
            return notFoundCell
        }
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath) as! TeamBadgeCollectionViewCell
            
            cell.teamBadgeImage.kf.setImage(with: URL(string: self.viewModel?.team?.first?.team_logo ?? "") , placeholder: UIImage(named: "no-image"))
            cell.teamStadiumImage.image = blurImage(image: UIImage(named: "stadium")!, radius: 2)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamInfoCell", for: indexPath) as! TeamInfoCollectionViewCell
            
            cell.coachLabel.text = viewModel?.team?.first?.coaches?.first?.coach_name
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamPlayerCell", for: indexPath) as! TeamPlayerCollectionViewCell
            
            cell.teamPlayerImage.kf.setImage(with: URL(string: (viewModel?.team?.first?.players?[indexPath.row].player_image) ?? ""), placeholder: UIImage(named: "person"))
            cell.teamPlayerImage.backgroundColor = UIColor.lightGray
            cell.teamPlayerImage.layer.cornerRadius = cell.teamPlayerImage.frame.width / 2
            
            cell.teamPlayerName.text = viewModel?.team?.first?.players?[indexPath.row].player_name ?? "Unknown"
            cell.TeamPlayerPosition.text = viewModel?.team?.first?.players?[indexPath.row].player_type ?? "Unknown"
            
            cell.TeamPlayerNumber.text = viewModel?.team?.first?.players?[indexPath.row].player_number ?? "N/A"

            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: " ", for: indexPath)
        }
    }
    
    func blurImage(image: UIImage, radius: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputCIImage = filter?.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }

}
