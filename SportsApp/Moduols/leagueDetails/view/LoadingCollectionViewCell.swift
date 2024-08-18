//
//  LoadingCollectionViewCell.swift
//  SportsApp
//
//  Created by Marco on 2024-08-17.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myIndicator.style = .large
        myIndicator.startAnimating()
        // Initialization code
    }

}
