//
//  EventsList_TableViewCell.swift
//  CatchUp
//
//  Created by Macbook on 12/25/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class EventsList_TableViewCell: UITableViewCell {

    @IBOutlet weak var event_ImageView: UIImageView!
    
    @IBOutlet weak var lbl_EventName: UILabel!
    
    @IBOutlet weak var lblEvent_Restaurant: UILabel!
    @IBOutlet weak var lblEvent_Date: UILabel!
    
    @IBOutlet weak var lblEvent_Type: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.event_ImageView.layer.cornerRadius = 5;
        self.event_ImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
