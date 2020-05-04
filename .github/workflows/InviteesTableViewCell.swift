//
//  InviteesTableViewCell.swift
//  CatchUp
//
//  Created by Macbook on 1/19/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

protocol inviteesCellDelegate : class {
    func inviteFriend(_ cell:InviteesTableViewCell,friend_id: String, group_id: String)
    func friendGrouplist(_ cell: InviteesTableViewCell, friend_group_Id:String)
}

class InviteesTableViewCell: UITableViewCell {

    @IBOutlet var verticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var topSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet var lbl_Invitee_Contact: UILabel!
    @IBOutlet var lbl_Invitee_Email: UILabel!
    
    @IBOutlet var lbl_Invitee_Name_Prefix: UILabel!
    @IBOutlet weak var lbl_Invitee_Name: UILabel!
    @IBOutlet weak var invitee_profile_img: UIImageView!
    @IBOutlet weak var btn_invitee_group: UIButton!
    @IBOutlet weak var btn_invitee: UIButton!
    
    weak var inviteeDelegate : inviteesCellDelegate!
    var invitee_friend : Friends!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.invitee_profile_img.layer.cornerRadius = self.invitee_profile_img.frame.size.width / 2;
        self.invitee_profile_img.clipsToBounds = true
        
//        btn_invitee_group.layer.cornerRadius = self.btn_invitee_group.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ invitee:Friends, isGroupList: Bool = true) {
        invitee_friend = invitee
        
        if isGroupList {
        
            lbl_Invitee_Name.text = invitee.friend_group_name
        }
        else {
        
            lbl_Invitee_Name.text = invitee.friend_name
    
        }
        
        
        //check friend is selected or not first
        //if selected mark checked else mark Invitee
        if Utitlity.sharedInstance.invitees_Array.count > 0 {
            let pred = NSPredicate(format: "friend_id == %@", argumentArray: [String(invitee_friend.friend_id)])
            let filterArr = Utitlity.sharedInstance.invitees_Array.filtered(using: pred)
            if filterArr.count > 0 {
                btn_invitee.isSelected = true
                btn_invitee.setTitle("", for: .selected)
//                btn_invitee.setImage(UIImage(named:"Request_accepted"), for: .selected)
                btn_invitee.setImage(UIImage(named:"sent_request"), for: .selected)
            }else{
                btn_invitee.isSelected = false
                btn_invitee.setTitle("Invitee", for: .normal)
                btn_invitee.setImage(nil, for: .normal)
            }
            
        }else{
            btn_invitee.isSelected = false
            btn_invitee.setTitle("Invitee", for: .normal)
            btn_invitee.setImage(nil, for: .normal)
        }

        if invitee.friend_image != "" {
            
            lbl_Invitee_Name_Prefix.isHidden = true
            
            
            invitee_profile_img.af_setImage(withURL: URL.init(string:invitee.friend_image)!, placeholderImage: #imageLiteral(resourceName: "placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                
                
            })
        }
        else {
        
            lbl_Invitee_Name_Prefix.isHidden = false
            invitee_profile_img.image = #imageLiteral(resourceName: "placeholderEmpty.png")
            
            lbl_Invitee_Name_Prefix.text = lbl_Invitee_Name.text?.getNameInitials() //constants.getPrefixName(FromName: lbl_Invitee_Name.text!)
            lbl_Invitee_Name_Prefix.textColor = .randomColor()
            
        }
        
        if invitee.friend_isCatchupUser {
            
            if self.topSpacingConstraint.isActive {
                
                self.topSpacingConstraint.isActive = false
            }
            
            self.lbl_Invitee_Email.text = ""
            self.lbl_Invitee_Contact.text = ""
            
            self.btn_invitee.isHidden = false
        }
        else {
        
            if self.topSpacingConstraint.isActive {
                
                self.topSpacingConstraint.isActive = true
            }
            
            self.lbl_Invitee_Email.text = invitee.friend_email
            self.lbl_Invitee_Contact.text = invitee.friend_phoneNumber
            
            self.btn_invitee.isHidden = true
        }
        
//        btn_invitee_group.setTitle(invitee.friend_group_name, for: .normal)
    }
    
    //MARK:- Buttons Action
    @IBAction func btn_invitee_Action(_ sender: Any) {
        self.inviteeDelegate?.inviteFriend(self, friend_id: String(invitee_friend.friend_id), group_id: String(invitee_friend.friend_gp_id))
    }
    @IBAction func btn_invitee_group_Action(_ sender: Any) {
        self.inviteeDelegate.friendGrouplist(self, friend_group_Id: String(invitee_friend.friend_gp_id))
    }
    
}
