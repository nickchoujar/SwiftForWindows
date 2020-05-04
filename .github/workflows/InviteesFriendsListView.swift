//
//  GroupFriendsListView.swift
//  CorvisApp
//
//  Created by Bilal Hussain on 2/13/17.
//  Copyright © 2017 Mohsin Ahmed. All rights reserved.
//

import UIKit

protocol InviteesFriendsListViewDelegate {
    func openFriendsProfile()
}

class InviteesFriendsListView: UIView {

    @IBOutlet weak var lbl_friend_name: UILabel!
    @IBOutlet weak var friendImgView: UIImageView!
    
    var delegate : InviteesFriendsListViewDelegate? = nil
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        friendImgView.layer.cornerRadius = friendImgView.frame.size.width/2
        friendImgView.layer.masksToBounds = true
    
        lbl_friend_name.adjustsFontSizeToFitWidth = true
    }

    func configrueFrieldDetail(_ freindDict:NSDictionary) {
        //frame of name label setting
        
        var attending:Int = (freindDict["inv_status"] as! Int)
        
        if attending == 1{
         lbl_friend_name.textColor = UIColor.green
        }
        else if attending == 2{
            lbl_friend_name.textColor = UIColor.red
        }
        else if attending == 3{
            lbl_friend_name.textColor = UIColor.orange
        }

        lbl_friend_name.text = (freindDict["name"] as! String)
        
        var frame = lbl_friend_name.frame
        frame.size.width = (lbl_friend_name.text?.widthOfString(usingFont: UIFont.init(name: "Arial", size: 14)!))!
        lbl_friend_name.frame = frame
        
        var friendImage = ""
        
        if let pic = freindDict["friend_picture"] as? String{
            friendImage = pic
        }
        
        
        if friendImage != "" {
            
            friendImgView.af_setImage(withURL: URL.init(string:friendImage)!, placeholderImage: UIImage(named:"placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                
                
            })
        }
        else {
        
            friendImgView.image = UIImage(named: "placeholder.png")
        }
       
        //view frame setting with lable
        var viewFrame = self.frame
        viewFrame.size.width = lbl_friend_name.frame.origin.x + lbl_friend_name.frame.size.width
        self.frame = viewFrame
        
    }
    @IBAction func btn_Profile_Action(_ sender: Any) {
        delegate?.openFriendsProfile()
    }
    
    
}
