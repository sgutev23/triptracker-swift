//
//  ActiveTripTableViewCell.swift
//  TripTracker
//
//  Created by Stan Gutev on 10/9/16.
//  Copyright © 2016 Stanislav Gutev. All rights reserved.
//

import UIKit

class ActiveTripTableViewCell: UITableViewCell {

    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
