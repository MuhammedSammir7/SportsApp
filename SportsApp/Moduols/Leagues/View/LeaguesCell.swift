//
//  LeaguesCell.swift
//  SportsApp
//
//  Created by ios on 13/08/2024.
//

import UIKit
import Kingfisher
class LeaguesCell: UITableViewCell {

    @IBOutlet weak var leagueBtn: UIButton!
    @IBOutlet weak var leagueNameLbl: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
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
            self.leagueImage.kf.setImage(with: url, placeholder: UIImage(named: "no-image"))
        self.leagueImage.layer.cornerRadius = self.leagueImage.frame.width/2
            self.leagueNameLbl.text = leagueName
        }
    @IBAction func LeagueVideoAction(_ sender: Any) {
    }
    
}
