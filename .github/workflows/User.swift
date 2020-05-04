
//
//  User.swift
//  CatchUp
//
//  Created by Macbook on 12/28/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    
    var user_Id         : Int64  = 0
    var user_fullname   : String!
    var user_name       : String!
    var user_email      : String!
    var user_password   : String!
    var user_phone      : String!
    var date_created    : String!
    var created_by      : String!
    var date_updated    : String!
    var modified_by     : String!
    var status          : String!
    var device_token    : String!
    var device_type     : String!
    
    
    var user_address    : String!
    var user_dob        : String!
    var facebook_id     : String!
    var skype_Id        : String!
    var user_Img_Url    : String!
    
    
    var groups_data     : [GroupObject] = []
    var cat_data        : [CategoryObject] = []
    var event_type_data : [EventTypeObject] = []
    
    private init(id:Int64, name:String, address:String, dob:String, fbid:String, skypeid:String, email:String, mobile_number:String, imgUrl:String, groupsData:NSArray, catData:NSArray, eventTypesData:NSArray) {
    }
    
    init(withDictionary dict: [String: AnyObject]) {
        
        let userDict = dict["data"]
        let groupDict = dict["group_data"]
        let catDict = dict["cat_data"]
        let eventTypeDict = dict["event_type_data"]
        
        self.user_Id            = (!(userDict?["user_id"] is NSNull)) ? userDict?["user_id"] as! Int64 : 0
        self.user_fullname      = (!(userDict?["user_fullname"] is NSNull)) ? userDict?["user_fullname"] as! String : ""
        self.user_name          = (!(userDict?["user_name"] is NSNull)) ? userDict?["user_name"] as! String : ""
        self.user_email         = (!(userDict?["user_email"] is NSNull)) ? userDict?["user_email"] as! String : ""
        self.user_password      = (!(userDict?["user_password"] is NSNull)) ? userDict?["user_password"] as! String : ""
        self.user_phone         = (!(userDict?["user_phone"] is NSNull)) ? userDict?["user_phone"] as! String : ""
        self.date_created       = (!(userDict?["date_created"] is NSNull)) ? userDict?["date_created"] as! String : ""
        self.created_by         = (!(userDict?["created_by"] is NSNull)) ? userDict?["created_by"] as! String : ""
        self.date_updated       = (!(userDict?["date_updated"] is NSNull)) ? userDict?["date_updated"] as! String : ""
        self.modified_by        = (!(userDict?["modified_by"] is NSNull)) ? userDict?["modified_by"] as! String : ""
        self.status             = (!(userDict?["status"] is NSNull)) ? userDict?["status"] as! String : ""
        self.device_token       = (!(userDict?["device_token"] is NSNull)) ? userDict?["device_token"] as! String : ""
        self.device_type        = (!(userDict?["device_type"] is NSNull)) ? userDict?["device_type"] as! String : ""
        
        self.user_address = ""
        self.user_dob = ""
        self.facebook_id = ""
        self.skype_Id = ""
        self.user_Img_Url = ""
        
        self.groups_data        = User.getGroupArray(fromDictionary: groupDict as! NSArray)
        self.cat_data           = User.getCategoryArray(fromDictionary: catDict as! NSArray)
        self.event_type_data    = User.getEventArray(fromDictionary: eventTypeDict as! NSArray)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(user_Id, forKey: "user_Id")
        aCoder.encode(user_name, forKey: "user_name")
        aCoder.encode(user_fullname, forKey: "user_fullname")
        aCoder.encode(user_email, forKey: "user_email")
        aCoder.encode(user_password, forKey: "user_password")
        aCoder.encode(user_phone, forKey: "user_phone")
        aCoder.encode(date_created, forKey: "date_created")
        aCoder.encode(created_by, forKey: "created_by")
        aCoder.encode(date_updated, forKey: "date_updated")
        aCoder.encode(modified_by, forKey: "modified_by")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(device_token, forKey: "device_token")
        aCoder.encode(device_type, forKey: "device_type")
        
        aCoder.encode(user_Img_Url, forKey: "user_Img_Url")
        aCoder.encode(user_address, forKey: "user_address")
        aCoder.encode(user_dob, forKey: "user_dob")
        aCoder.encode(facebook_id, forKey: "facebook_id")
        aCoder.encode(skype_Id, forKey: "skype_Id")
        
        aCoder.encode(groups_data, forKey: "groups_data")
        aCoder.encode(cat_data, forKey: "cat_data")
        aCoder.encode(event_type_data, forKey: "event_type_data")
    }
    
    required init?(coder aDecoder: NSCoder){
        
        self.user_Id            = Int64(aDecoder.decodeInt64(forKey: "user_Id"))
        self.user_fullname          = aDecoder.decodeObject(forKey: "user_fullname") as! String!
        self.user_name         = aDecoder.decodeObject(forKey: "user_name") as! String!
        self.user_email         = aDecoder.decodeObject(forKey: "user_email") as! String!
        self.user_password         = aDecoder.decodeObject(forKey: "user_password") as! String!
        self.user_phone         = aDecoder.decodeObject(forKey: "user_phone") as! String!
        self.date_created         = aDecoder.decodeObject(forKey: "date_created") as! String!
        self.created_by         = aDecoder.decodeObject(forKey: "created_by") as! String!
        self.date_updated         = aDecoder.decodeObject(forKey: "date_updated") as! String!
        self.modified_by         = aDecoder.decodeObject(forKey: "modified_by") as! String!
        self.status         = aDecoder.decodeObject(forKey: "status") as! String!
        self.device_token         = aDecoder.decodeObject(forKey: "device_token") as! String!
        self.device_type         = aDecoder.decodeObject(forKey: "device_type") as! String!
        
        self.user_address       = aDecoder.decodeObject(forKey: "user_address") as! String!
        self.user_dob           = aDecoder.decodeObject(forKey: "user_dob") as! String!
        self.facebook_id        = aDecoder.decodeObject(forKey: "facebook_id") as! String!
        self.skype_Id           = aDecoder.decodeObject(forKey: "skype_Id") as! String!
//        self.user_Mob_Number    = aDecoder.decodeObject(forKey: "user_Mob_Number") as! String!
        self.user_Img_Url       = aDecoder.decodeObject(forKey: "user_Img_Url") as! String!
        
        self.groups_data        = aDecoder.decodeObject(forKey: "groups_data") as! [GroupObject]
        self.cat_data           = aDecoder.decodeObject(forKey: "cat_data") as! [CategoryObject]
        self.event_type_data    = aDecoder.decodeObject(forKey: "event_type_data") as! [EventTypeObject]
        
    }
    
    private class func getGroupArray(fromDictionary arrayValue: NSArray) -> [GroupObject] {
    
        var groupArray: [GroupObject] = []
        
        for index in 0..<arrayValue.count {
            
            let dictValue: [String: AnyObject] = arrayValue[index] as! [String : AnyObject]
         
            let groupObject = GroupObject(groupId: dictValue["group_id"] as! Int64, groupName: dictValue["group_name"] as! String)
            
            groupArray.append(groupObject)
        }
        
        return groupArray
    }
    
    private class func getCategoryArray(fromDictionary arrayValue: NSArray) -> [CategoryObject] {
        
        var categoryArray: [CategoryObject] = []
        
        for index in 0..<arrayValue.count {
            
            let dictValue: [String: AnyObject] = arrayValue[index] as! [String : AnyObject]
            
            let categoryObject = CategoryObject(categoryId: dictValue["cat_id"] as! Int64, categoryName: dictValue["cat_name"] as! String)
            
            categoryArray.append(categoryObject)
        }
        
        return categoryArray
    }
    
    private class func getEventArray(fromDictionary arrayValue: NSArray) -> [EventTypeObject] {
        
        var eventTypeArray: [EventTypeObject] = []
        
        for index in 0..<arrayValue.count {
            
            let dictValue: [String: AnyObject] = arrayValue[index] as! [String : AnyObject]
            
            let eventObject = EventTypeObject(eventId: dictValue["event_type_id"] as! Int64, eventType: dictValue["event_type"] as! String, picture: dictValue["picture"] as! String)
            
            eventTypeArray.append(eventObject)
        }
        
        return eventTypeArray
    }
}

class GroupObject: NSObject, NSCoding {

    var group_id    :  Int64  = 0
    var group_name  :  String!
    
    override init() {
        super.init()
        
        self.group_id = 0
        self.group_name = ""
    }
    
    init(groupId: Int64, groupName: String) {
        super.init()
        
        self.group_id = groupId
        self.group_name = groupName
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(group_id, forKey: "group_id")
        aCoder.encode(group_name, forKey: "group_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.group_id            = Int64(aDecoder.decodeInt64(forKey: "group_id"))
        self.group_name          = aDecoder.decodeObject(forKey: "group_name") as! String!
    }
}

class CategoryObject: NSObject, NSCoding {
    
    var cat_id    :  Int64  = 0
    var cat_name  :  String!
    
    override init() {
        super.init()
        
        self.cat_id = 0
        self.cat_name = ""
    }
    
    init(categoryId: Int64, categoryName: String) {
        super.init()
        
        self.cat_id = categoryId
        self.cat_name = categoryName
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(cat_id, forKey: "cat_id")
        aCoder.encode(cat_name, forKey: "cat_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.cat_id            = Int64(aDecoder.decodeInt64(forKey: "cat_id"))
        self.cat_name          = aDecoder.decodeObject(forKey: "cat_name") as! String!
    }
}

class EventTypeObject: NSObject, NSCoding {
    
    var event_type_id    :  Int64  = 0
    var event_type       :  String!
    var picture          :  String!
    
    override init() {
        super.init()
        
        self.event_type_id = 0
        self.event_type = ""
        self.picture = ""
    }
    
    init(eventId: Int64, eventType: String, picture: String) {
        super.init()
        
        self.event_type_id = eventId
        self.event_type = eventType
        self.picture = picture
    }
    
    func encode(with aCoder: NSCoder) {
    
        aCoder.encode(event_type_id, forKey: "event_type_id")
        aCoder.encode(event_type, forKey: "event_type")
        aCoder.encode(picture, forKey: "picture")
    }
    
    required init?(coder aDecoder: NSCoder) {
    
        self.event_type_id            = Int64(aDecoder.decodeInt64(forKey: "event_type_id"))
        self.event_type          = aDecoder.decodeObject(forKey: "event_type") as! String!
        self.picture          = aDecoder.decodeObject(forKey: "picture") as! String!
    }
}
