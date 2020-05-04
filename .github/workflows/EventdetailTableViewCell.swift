//
//  EventdetailTableViewCell.swift
//  CatchUp
//
//  Created by Bilal Hussain on 2/23/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class EventdetailTableViewCell: UITableViewCell {

    @IBOutlet var eventImageHConstraint: NSLayoutConstraint!
    @IBOutlet var eventTypeHConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var event_imgVIew: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var enentDetail: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var scl_Invitees: UIScrollView!
    @IBOutlet var warningLabel: UILabel!
    
    @IBOutlet var btnAttendYes: UIButton!
    @IBOutlet var btnAttendNo: UIButton!
    @IBOutlet var btnAttendMaybe: UIButton!
    @IBOutlet var lblAttnedStatus: UILabel!
    
    var lastViewX : CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.scl_Invitees.showsHorizontalScrollIndicator = false
//        self.scl_Invitees.showsVerticalScrollIndicator = false
//        self.scl_Invitees.alwaysBounceVertical = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(_ inviteesArray : NSArray){
        
        if inviteesArray.count > 0 {
            
            self.warningLabel.isHidden = true
        }
        else {
        
            self.warningLabel.isHidden = false
        }
        
        let subViews = self.scl_Invitees.subviews
        for subview in subViews{
                subview.removeFromSuperview()
        }
        self.lastViewX = 0
        
        for i in 0..<inviteesArray.count {
            setFriendsList(inviteesArray[i] as! NSDictionary)
        }
    }
}

//MARK :- Accounts options
extension EventdetailTableViewCell {
    func setFriendsList(_ friendDict:NSDictionary) {
        if let customFriendsView = Bundle.main.loadNibNamed("InviteesFriendsList", owner: self, options: nil)?.first as? InviteesFriendsListView {
            customFriendsView.frame.origin.x = lastViewX
            self.scl_Invitees.addSubview(customFriendsView)
            customFriendsView.configrueFrieldDetail(friendDict)
            lastViewX = customFriendsView.frame.origin.x + customFriendsView.frame.size.width
            self.scl_Invitees.contentSize = CGSize(width: lastViewX+20, height: self.scl_Invitees.frame.size.height)
            self.scl_Invitees.scrollRectToVisible(customFriendsView.frame, animated: true)
        }
        
    }
}

