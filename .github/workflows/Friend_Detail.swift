//
//  Friend_Detail.swift
//  CatchUp
//
//  Created by Macbook on 1/17/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class Friend_Detail: NSObject {
    var friend_id : Int64!
    var friend_name : String!
    var friend_image :String?
    var friend_group_name : String!
    var friend_address : String!
    var friend_Dob : String!
    var friend_Facebook_Id : String!
    var friend_Skype_Id    : String!
    var friend_Email       : String!
    var friend_Mobile_no   : String!
    var friend_thum_img_url : String?
    
    init(fid:Int64, fName:String, fImage:String, fgname:String, faddress:String, fDob:String, fFb_Id:String, fskype_Id:String, fEmail:String, fMobileNo:String, fthumbImgUrl:String) {
        self.friend_id = fid
        self.friend_name = fName
        
        self.friend_group_name = fgname
        self.friend_address = faddress
        self.friend_Dob  = fDob
        self.friend_Facebook_Id = fFb_Id
        self.friend_Skype_Id = fskype_Id
        self.friend_Email    = fEmail
        self.friend_Mobile_no = fMobileNo
        if fid == Utitlity.sharedInstance.user_profile?.user_Id {//user image
            self.friend_thum_img_url = fthumbImgUrl
        
            self.friend_image = paths.Img_Base_Url+"users/"+fImage
        }else{
        
            self.friend_image = paths.Img_Base_Url+"friends/"+fImage
            self.friend_thum_img_url = paths.Img_Base_Url+"friends/"+fthumbImgUrl
        }
    }
}
