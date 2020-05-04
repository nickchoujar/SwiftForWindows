//
//  Friends.swift
//  CatchUp
//
//  Created by Macbook on 12/28/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class Friends: NSObject {

    var friend_id : Int64!
    var friend_name : String!
    var friend_image :String!
    var friend_group_name : String!
    var friend_gp_id : Int64!
    var friend_isCatchupUser : Bool = false

    var friend_email: String!
    var friend_phoneNumber: String!
    
    override init() {
        super.init()
        
        self.friend_id = 0
        self.friend_name = ""
        self.friend_image = ""
        self.friend_group_name = ""
        self.friend_gp_id = 0
        self.friend_isCatchupUser = false
        
        self.friend_email = ""
        self.friend_phoneNumber = ""
        
    }
    
    init(fid:Int64, fName:String, fImage:String, fgname:String, fgId:Int64, isCatchupUser: Bool, fEmail: String = "", fPhoneNumber: String = "") {
        
        super.init()
        
        self.friend_id = fid
        self.friend_name = fName
        
        if fImage == "" {
            
            self.friend_image = fImage
        }
        else {
        
            self.friend_image = paths.Img_Base_Url+"friends/thumbs/"+fImage
        }
        
        self.friend_group_name  = fgname
        self.friend_gp_id = fgId
        
        self.friend_isCatchupUser = isCatchupUser
        
        self.friend_email = fEmail
        self.friend_phoneNumber = fPhoneNumber
    }
    
    class func getAllFriendsList() -> NSMutableArray {
        
        
        let listFromDB: [FriendList] = FriendList.mr_findAllSorted(by: "isCatchupUser", ascending: false) as! [FriendList]
        
        let resultArrray: NSMutableArray = NSMutableArray()
        
        for friendDB in listFromDB {
            
            resultArrray.add(ModelConverter.convertToFriends(fromFriendList: friendDB))
        }
    
        return resultArrray;
    }
    
    class func getFriendsList(isCatchUpUser: Bool = true) -> NSMutableArray {
    
        let predicate = NSPredicate(format: "isCatchupUser = \(isCatchUpUser)")

        let listFromDB: [FriendList] = FriendList.mr_findAll(with: predicate) as! [FriendList]
        
//        let listFromDB: [FriendList] = FriendList.mr_findAll() as! [FriendList]
        
        let resultArrray: NSMutableArray = NSMutableArray()
        
        for friendDB in listFromDB {
            
            resultArrray.add(ModelConverter.convertToFriends(fromFriendList: friendDB))
        }
        
        return resultArrray
    }
    
    class func getPhoneContactsList() -> NSMutableArray {
    
        let predicate = NSPredicate(format: "isCatchupUser = \(false)")
        
        let listFromDB: [PhoneContactList] = PhoneContactList.mr_findAllSorted(by: "fullName", ascending: true, with: predicate) as! [PhoneContactList]
        
        let resultArray: NSMutableArray = NSMutableArray()
        
        for phoneContactDB in listFromDB {
            
            resultArray.add(ModelConverter.convertToFriends(fromPhoneContactList: phoneContactDB))
        }
        
        return resultArray
    }
    
    
    class func getMobileOnlyContacts(contacts:[[String:String]]) -> NSMutableArray {
        
        let resultArray: NSMutableArray = NSMutableArray()
        for phoneContactDB in contacts {
            if((phoneContactDB["email"]?.characters.count)! < 1){
            
            let friend = Friends(fid: 0, fName: phoneContactDB["fname"] ?? "", fImage: "", fgname: "", fgId: 0, isCatchupUser: false, fEmail: "", fPhoneNumber: phoneContactDB["phoneNumber"] ?? "")
        
            resultArray.add(friend)
            }
        }
  
        return resultArray
    }

}
