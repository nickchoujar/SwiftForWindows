//
//  MenuTableViewCell.swift
//  CatchUp
//
//  Created by Macbook on 12/24/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var icon_imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
