//
//  UpComingCollectionViewCell.swift
//  SportsApp
//
//  Created by Marco on 2024-08-11.
//

import UIKit

class UpComingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var live: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var scoreSeparator: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgoundImage: UIImageView!
    @IBOutlet weak var vsImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var AwayTeamImage: UIImageView!
    @IBOutlet weak var HomeTeamImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //backgoundImage.image = blurImage(image: backgoundImage.image!, radius: 6)
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
