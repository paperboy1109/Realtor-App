//
//  HomeListTableViewCell.swift
//  Realtor-App
//
//  Created by Daniel J Janiak on 7/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class HomeListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var homeImageView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var priceValueLabel: UILabel!
    @IBOutlet var bedValueLabel: UILabel!
    @IBOutlet var bathValueLabel: UILabel!
    @IBOutlet var sqftValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
