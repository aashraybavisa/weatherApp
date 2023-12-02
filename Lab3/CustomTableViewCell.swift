//
//  CustomTableViewCell.swift
//  Lab3
//
//  Created by Aashray Bavisa on 2023-12-01.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var conditionImg: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
