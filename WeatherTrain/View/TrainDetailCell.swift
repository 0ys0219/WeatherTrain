//
//  TrainDetailCell.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/17.
//

import UIKit

class TrainDetailCell: UITableViewCell {

    @IBOutlet weak var startStation: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var endStation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
