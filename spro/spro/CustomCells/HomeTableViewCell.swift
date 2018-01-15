//
//  HomeTableViewCell.swift
//  spro
//
//  Created by Sam Kortekaas on 13/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
//    func update(with coffeeBar: JSON) {
//        nameLabel.text = coffeeBar["venue"]["name"]
//        distanceLabel.text = String(coffeeBar.distance)
//        ratingLabel.text = String(coffeeBar.rating)
//        barImageView.image = UIImage(named: "Toki")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
