//
//  LeaguesCell.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import UIKit
import Kingfisher
class LeaguesCell: UITableViewCell {

    @IBOutlet weak var LeagueImage: UIImageView!
    @IBOutlet weak var LeagueNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(leagueName: String, leagueImage: String) {
            // Safely handle the optional URL
            let url = URL(string: leagueImage)
            self.LeagueImage.kf.setImage(with: url, placeholder: UIImage(named: "no-image"))
        self.LeagueImage.layer.cornerRadius = self.LeagueImage.frame.width/2
            self.LeagueNameLbl.text = leagueName
        }

    
    @IBAction func youtubeVideoBtn(_ sender: Any) {
    }
}
