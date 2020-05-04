//
//  SearchLocationTableViewCell.swift
//  CatchUp
//
//  Created by Macbook on 1/20/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import Cosmos
class SearchLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurant_imgView: UIImageView!
    @IBOutlet weak var lbl_Rest_Name: UILabel!
    @IBOutlet weak var lbl_rest_detail: UILabel!
    @IBOutlet weak var lbl_rest_time: UILabel!
    @IBOutlet weak var rate_View: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(_ location:NearestLocation)  {
        lbl_Rest_Name.text = location.loc_Name
        lbl_rest_detail.text = location.loc_address
        lbl_rest_time.text   = location.loc_open_time
        
        if  location.loc_img_url != nil && location.loc_img_url != "" {
        
            restaurant_imgView.af_setImage(withURL: URL.init(string: location.loc_img_url)!, placeholderImage: UIImage(named:"placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                
                
            })
        }
        
        if location.loc_rate != "" {
            rate_View.rating = Double(location.loc_rate)!
        }
        
    }
}
