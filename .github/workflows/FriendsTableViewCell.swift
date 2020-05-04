//
//  FriendsTableViewCell.swift
//  CatchUp
//
//  Created by Macbook on 12/27/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import AlamofireImage

protocol FriendsTableViewCellDelegate {
    
    func friendsTableViewCell(_ cell: FriendsTableViewCell, friend: Friends)
}

class FriendsTableViewCell: UITableViewCell {

    
    
    @IBOutlet var verticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var topSpacingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var friend_ImgView: UIImageView!
    @IBOutlet weak var lblFriend_Name: UILabel!
    
    @IBOutlet var lblFriend_Email: UILabel!
    @IBOutlet var lblFriend_Number: UILabel!
    @IBOutlet var lblFriend_Prefix: UILabel!
//    @IBOutlet var lblCatchupUser: UILabel!
    @IBOutlet var btnContactUser: UIButton!
    
    @IBOutlet weak var imageViewContact: UIImageView!
    
    var delegate: FriendsTableViewCellDelegate!
    var contactFriend : Friends!
    
    var friendControllerType: FriendControllerType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.friend_ImgView.layer.cornerRadius = self.friend_ImgView.frame.size.width / 2;
        self.friend_ImgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureFriendsCell(_ contact:Friends, controllerType:FriendControllerType) {
    
        self.contactFriend = contact
        self.friendControllerType = controllerType
        let predicate = NSPredicate(format: "friend_Number == %@", argumentArray: [self.contactFriend.friend_phoneNumber])
        var title: String = "Invitee via SMS"
        if self.contactFriend.friend_email != "" {
            title = ""
        }
        self.setupBasicUI(title)
        if self.contactFriend.friend_email != "" {
            self.btnContactUser.isEnabled = false
            if !self.contactFriend.friend_isCatchupUser {
                
                self.btnContactUser.isHidden = true
                self.imageViewContact.isHidden = true
                self.btnContactUser.setImage(nil, for: .normal)
            }
            else {
            
                self.btnContactUser.isHidden = true
                self.imageViewContact.isHidden = false
                self.imageViewContact.image = UIImage(named:"CatchupUser")?.af_imageRoundedIntoCircle()
            }
        }
        else {
        
            self.btnContactUser.isEnabled = true
            self.btnContactUser.isHidden = false
            self.btnContactUser.setImage(nil, for: .normal)
            self.buttonStateChange(predicate: predicate)
        }
    }
    
    func buttonStateChange(predicate: NSPredicate) {
    
        if Utitlity.sharedInstance.contacts_Array.count > 0 {
            let filterArr = Utitlity.sharedInstance.contacts_Array.filtered(using: predicate)
            if filterArr.count > 0 {
                self.btnContactUser.isSelected = true
                self.btnContactUser.setImage(UIImage(named:"sent_request"), for: .selected)
            }else{
                self.btnContactUser.isSelected = false
                self.btnContactUser.setImage(nil, for: .normal)
            }
        }
        else{
            self.btnContactUser.isSelected = false
            self.btnContactUser.setImage(nil, for: .normal)
        }
    }
    
    func configureInviteesCell(_ contact:Friends, btnTitle: String = "Invitee", controllerType:FriendControllerType) {
    
        self.contactFriend = contact
        self.friendControllerType = controllerType
        let predicate = NSPredicate(format: "friend_id = %@", argumentArray: [String(contact.friend_id)])
        self.setupBasicUI(btnTitle)
        self.buttonStateChange(predicate: predicate)
    }

    func configureInviteesCellForPhoneNumbers(_ contact:Friends, btnTitle: String = "Invitee", controllerType:FriendControllerType) {
        self.contactFriend = contact
        self.friendControllerType = controllerType
        let predicate = NSPredicate(format: "friend_phoneNumber = %@", argumentArray: [contact.friend_phoneNumber])
        self.setupBasicUI(btnTitle)
        self.buttonStateChange(predicate: predicate)
    }

    
    private func setupBasicUI(_ btnTitle: String) {
        self.imageViewContact.isHidden = true
        
        let attributedString: NSAttributedString = NSAttributedString(string: btnTitle)
        self.btnContactUser.setAttributedTitle(attributedString, for: .normal)
        self.btnContactUser.titleLabel?.textAlignment = .center
        self.btnContactUser.titleLabel?.textColor = UIColor.white
        /// set cell values
        self.lblFriend_Name.text = self.contactFriend.friend_name!
        if(self.contactFriend.friend_email.characters.count > 0){
            self.lblFriend_Number.text = self.contactFriend.friend_email
        }
        else{
            self.lblFriend_Number.text = self.contactFriend.friend_phoneNumber
        }
        if self.contactFriend.friend_image != "" {
            
            self.lblFriend_Prefix.isHidden = true
            
            let url = URL(string: self.contactFriend.friend_image)
            
            self.friend_ImgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                
                if dataResponse.result.value != nil {
                    
                    self.friend_ImgView.image = dataResponse.result.value?.fixOrientation()
                }
            })
        }
        else {
            
            self.lblFriend_Prefix.isHidden = false
            
            self.friend_ImgView.image = #imageLiteral(resourceName: "placeholderEmpty.png")
            self.friend_ImgView.image = #imageLiteral(resourceName: "placeholderEmpty.png")
            
            self.lblFriend_Prefix.text = self.contactFriend.friend_name.getNameInitials()
            self.lblFriend_Prefix.textColor = .randomColor()
        }
    }
    
    private func configureCell(_ contact:Friends, btnContactTitle: String, withPredicate predicate: NSPredicate, isInviteesCell: Bool = false) {
        
        
        
//        self.btnContactUser.titleLabel?.font = UIFont(name: "Myriad Pro Regular", size: 12)
//        
//        /// check friend is selected or not first
//        /// if selected mark checked else mark Invitee
//        
//        if isInviteesCell {
//            
//            
//        }
//        else {
//        
//            self.btnContactUser.isSelected = false
//            self.btnContactUser.setAttributedTitle(attributedString, for: .normal)
//            
//            // for email section
//            if self.contactFriend.friend_email != "" {
//             
//                self.btnContactUser.isEnabled = false
//                
//                if self.contactFriend.friend_isCatchupUser {
//                
//                    self.btnContactUser.setImage(UIImage(named:"CatchupUser"), for: .selected)
//                }
//                else {
//                    
//                    self.btnContactUser.setImage(nil, for: .normal)
//                }
//                
//                self.lblFriend_Email.text = ""
//                self.lblFriend_Number.text = ""
//                
//                self.btnContactUser.isHidden = false
//            }
//            else {
//                // for mobile section
//                
//                self.btnContactUser.isEnabled = true
//                
//                if Utitlity.sharedInstance.contacts_Array.count > 0 {
//                    
//                    
//                    let filterArr = Utitlity.sharedInstance.contacts_Array.filtered(using: predicate)
//                    
//                    if filterArr.count > 0 {
//                        
//                        self.btnContactUser.isSelected = true
//                        self.btnContactUser.setAttributedTitle(NSAttributedString(string: ""), for: .selected)
//                        
//                        self.btnContactUser.setImage(UIImage(named:"sent_request"), for: .selected)
//                    }else{
//                        self.btnContactUser.isSelected = false
//                        
//                        self.btnContactUser.setAttributedTitle(attributedString, for: .normal)
//                        self.btnContactUser.setImage(nil, for: .normal)
//                    }
//                    
//                }else{
//                    
//                    self.btnContactUser.isSelected = false
//                    
//                    self.btnContactUser.setAttributedTitle(attributedString, for: .normal)
//                    self.btnContactUser.setImage(nil, for: .normal)
//                }
//            }
//        }
        
//        if Utitlity.sharedInstance.contacts_Array.count > 0 {
//            
//            
//            let filterArr = Utitlity.sharedInstance.contacts_Array.filtered(using: predicate)
//            
//            if filterArr.count > 0 {
//            
//                self.btnContactUser.isSelected = true
//                self.btnContactUser.setAttributedTitle(NSAttributedString(string: ""), for: .selected)
//
//                self.btnContactUser.setImage(UIImage(named:"sent_request"), for: .selected)
//            }else{
//                self.btnContactUser.isSelected = false
//
//                self.btnContactUser.setAttributedTitle(attributedString, for: .normal)
//                self.btnContactUser.setImage(nil, for: .normal)
//            }
//            
//        }else{
//            
//            self.btnContactUser.isSelected = false
//
//            self.btnContactUser.setAttributedTitle(attributedString, for: .normal)
//            self.btnContactUser.setImage(nil, for: .normal)
//        }
        
        /// Do'nt show invitee button for already catchup users.
        
//        if contact.friend_isCatchupUser {
//            
//
//            if self.topSpacingConstraint.isActive {
//                
//                self.topSpacingConstraint.isActive = false
//            }
//            
//            self.lblFriend_Email.text = ""
//            self.lblFriend_Number.text = ""
//            
//            self.btnContactUser.isHidden = true
//        }
//        else {
//            
//            if !self.topSpacingConstraint.isActive {
//                
//                self.topSpacingConstraint.isActive = true
//            }
//            
//            self.lblFriend_Email.text = contact.friend_email
//            self.lblFriend_Number.text = contact.friend_phoneNumber
//        
//            self.btnContactUser.isHidden = false
//        }
        
    }
    
    
    @IBAction func didInviteButtonPressed(_ sender: UIButton) {
        
        if self.friendControllerType == FriendControllerType.FriendsList {
            
            if self.contactFriend.friend_email == "" {
         
                if let delegate = self.delegate {
                    
                    delegate.friendsTableViewCell(self, friend: self.contactFriend)
                }
            }
        }
        else {
        
            if let delegate = self.delegate {
                
                delegate.friendsTableViewCell(self, friend: self.contactFriend)
            }
        }
    }
    /*
     
     btn_invitee.isSelected = true
     btn_invitee.setTitle("", for: .selected)
     btn_invitee.setImage(UIImage(named:"Request_accepted"), for: .selected)
     }else{
     btn_invitee.isSelected = false
     btn_invitee.setTitle("Invitee", for: .normal)
     btn_invitee.setImage(nil, for: .normal)
     
     */

}





/*
 
 if email
 {
    all email and catchup users
    
    if catchup users {
    
        show catchup icon
    }
    else {
    
        show nothing
    }
 }
 else {
 
    have only mobile numbers users show invitee button
 }
 
 
 
 
 */


