//
//  ProfileTableViewCell.swift
//  CatchUp
//
//  Created by Macbook on 1/14/17.
//  Copyright © 2017 Macbook. All rights reserved.
// 47,61,74

import UIKit

protocol profileCellDelegate : class  {
    func updateProfile(_ cell:ProfileTableViewCell)
    func deleteFriend(_ cell:ProfileTableViewCell)
    func updateProflePicture(_ cell:ProfileTableViewCell)
    func saveUpdatedProfile(_ cell:ProfileTableViewCell)
    func cancelUpdatedProfile(_ cell:ProfileTableViewCell)
}

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var profileImageHConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var profile_ImgView: UIImageView!
    @IBOutlet weak var icon_imgView: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_detail: UITextField!
    @IBOutlet weak var txt_detail_bg: UIView!
    @IBOutlet weak var btn_Delete_User: UIButton!
    @IBOutlet weak var btn_Camera: UIButton!
    @IBOutlet weak var btn_Edit: UIButton!
    
    
    var indexPath : NSInteger = 0
    var friend_detail : Friend_Detail!
    weak var profileDelegate : profileCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK :- Buttons Actions
    @IBAction func btn_Edit_Action(_ sender: Any) {
        profileDelegate?.updateProfile(self)
    }
    
    @IBAction func btn_delete_user_Action(_ sender: Any) {
        profileDelegate?.deleteFriend(self)
    }
    
    @IBAction func btn_Camera_Action(_ sender: Any) {
        profileDelegate?.updateProflePicture(self)
    }
    @IBAction func btn_Save_Action(_ sender: Any) {        
        self.updateProfleWithData()
        profileDelegate?.saveUpdatedProfile(self)
    }
    @IBAction func btn_Cancel_Action(_ sender: Any) {
        profileDelegate?.cancelUpdatedProfile(self)
    }
    
    //MARK :- configure cells data
    func configureCell(_ friend:Friend_Detail, isCellEditable:Bool) {
        friend_detail = friend
        if indexPath == 0 {//profile image setting
            profile_ImgView.layer.cornerRadius = profile_ImgView.frame.size.width / 2
            profile_ImgView.clipsToBounds = true
            if friend.friend_image != "" {
                
                profile_ImgView.af_setImage(withURL: URL.init(string:friend.friend_image!)!, placeholderImage: UIImage(named:"placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                    
                    
                })
            }else{
                profile_ImgView.image = UIImage(named: "placeholder.png")
            }
            //enable or disable editing mode
            if isCellEditable {
                btn_Camera.isHidden = false
            }else{
                btn_Camera.isHidden = true
            }
        }else{// profile detail setting
            //enable or disable editing mode
            if isCellEditable {
                txt_detail.isEnabled = true
                txt_detail_bg.backgroundColor = UIColor(red: 47.0/255.0, green: 61.0/255.0, blue: 74.0/255.0, alpha: 1)
            }else {
                txt_detail.isEnabled = false
                txt_detail_bg.backgroundColor = UIColor.clear
            }
            self.updateCellsWithData(friend)
        }
        
    }

    func updateCellsWithData(_ friend:Friend_Detail) {
        switch self.lbl_title.text! {
        case "Full Name":
            txt_detail.text = friend.friend_name
            txt_detail.keyboardType = UIKeyboardType.default
            break
        case "Friend Name":
            txt_detail.text = friend.friend_name
            break
        case "Address":
            txt_detail.text = friend.friend_address
            break
        case "Date of Birth":
            txt_detail.text = "" //friend.friend_Dob
            break
        case "Facebook ID":
            txt_detail.text = friend.friend_Facebook_Id
            
            break
        case "Skype ID":
            txt_detail.text = friend.friend_Skype_Id
            break
        case "Email":
            txt_detail.text = friend.friend_Email
            txt_detail.keyboardType = UIKeyboardType.emailAddress
            break
        case "Mobile No.":
            txt_detail.text = friend.friend_Mobile_no
            txt_detail.keyboardType = UIKeyboardType.phonePad
            break
        default:
            break
        }
    }
}

extension ProfileTableViewCell:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateProfleWithData()
    }
    
    func updateProfleWithData(){
        switch self.lbl_title.text! {
        case "Full Name":
            Utitlity.sharedInstance.updated_user_profile_Detail?.user_name = txt_detail.text
            break
        case "Friend Name":
            Utitlity.sharedInstance.updated_friend_detail?.friend_name = txt_detail.text
            break
        case "Address":
            Utitlity.sharedInstance.updated_friend_detail?.friend_address = txt_detail.text
            break
        case "Date of Birth":
            Utitlity.sharedInstance.updated_friend_detail?.friend_Dob = txt_detail.text
            break
        case "Facebook ID":
            Utitlity.sharedInstance.updated_friend_detail?.friend_Facebook_Id = txt_detail.text
            break
        case "Skype ID":
            Utitlity.sharedInstance.updated_friend_detail?.friend_Skype_Id = txt_detail.text
            break
        case "Email":
            if friend_detail.friend_id == Utitlity.sharedInstance.user_profile?.user_Id {//user update profile
                Utitlity.sharedInstance.updated_user_profile_Detail?.user_email = txt_detail.text
            }else{
                Utitlity.sharedInstance.updated_friend_detail?.friend_Email = txt_detail.text
            }
            break
        case "Mobile No.":
            if friend_detail.friend_id == Utitlity.sharedInstance.user_profile?.user_Id {//user update profile
                Utitlity.sharedInstance.updated_user_profile_Detail?.user_phone = txt_detail.text
            }else{
                Utitlity.sharedInstance.updated_friend_detail?.friend_Mobile_no = txt_detail.text
            }
            break
        default:
            break
        }
    }
}
