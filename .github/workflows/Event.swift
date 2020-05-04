//
//  Event.swift
//  CatchUp
//
//  Created by Macbook on 12/28/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    var event_id : Int = 0
    var venue_address : String!
    var venue_link    : String!
    var venue_late    : Double!
    var venue_long    : Double!
    var venue_location: String!
    var event_type    : String!
    var event_Picture : String!
    var event_privacy : String!
    var event_date    : String!
    var event_time    : String!
    var event_cat_id  : String!
    var invitees      : NSArray = []
    var schedules     : NSMutableArray = []
    var event_name    : String!
    var event_user_Name    : String!
    var event_user_Pic    : String!
    var eventDateTime    : Date!
    var attendingStatus    : Int = 0
    
    
    init(responseDict: Dictionary<String, Any>) {

        /// if event_id key does not exist in response means response is invalid
        assert(responseDict.contains(Key: "event_id"), "The server response is invalid, please check response of this request.\n")
        
        
        /// event_id
        if responseDict.contains(Key: "event_id") {
            
            if let eventId = responseDict["event_id"] as? Int {
                
                self.event_id = eventId
            }
            else {
                
                self.event_id = 0
            }
        }
        else {
            
            self.event_id = 0
        }
        
        /// venue_address
        if responseDict.contains(Key: "venue_address") {
            
            if let venue_address = responseDict["venue_address"] as? String {
                
                self.venue_address = venue_address
            }
            else {
                
                self.venue_address = ""
            }
        }
        else {
            
            self.venue_address = ""
        }
        
        /// venue_late
        if responseDict.contains(Key: "venue_late") {
            
            if let venue_late = responseDict["venue_late"] as? String {
                
                self.venue_late = Double(venue_late)
            }
            else {
                
                self.venue_late = Double(0)
            }
        }
        else {
            
            self.venue_late = Double(0)
        }
        
        /// venue_long
        if responseDict.contains(Key: "venue_long") {
            
            if let venue_long = responseDict["venue_long"] as? String {
                
                self.venue_long = Double(venue_long)
            }
            else {
                
                self.venue_long = Double(0)
            }
        }
        else {
            
            self.venue_long = Double(0)
        }
        
        /// venue_location
        if responseDict.contains(Key: "venue_location") {
            
            if let venue_location = responseDict["venue_location"] as? String {
                
                self.venue_location = venue_location
            }
            else {
                
                self.venue_location = ""
            }
        }
        else {
            
            self.venue_location = ""
        }
        
        /// event_type
        if responseDict.contains(Key: "event_type") {
            
            if let event_type = responseDict["event_type"] as? String {
                
                self.event_type = event_type
            }
            else {
                
                self.event_type = ""
            }
        }
        else {
            
            self.event_type = ""
        }
        
        /// event_privacy
        if responseDict.contains(Key: "event_privacy") {
            
            if let event_privacy = responseDict["event_privacy"] as? String {
                
                self.event_privacy = event_privacy
            }
            else {
                
                self.event_privacy = ""
            }
        }
        else {
            
            self.event_privacy = ""
        }
        
        /// event_status
        if responseDict.contains(Key: "event_status") {
            
            if let event_status = responseDict["event_status"] as? Int {
                
                self.attendingStatus = event_status
            }
            else {
                
                self.attendingStatus = 0
            }
        }
        else {
            
            self.attendingStatus = 0
        }
        
        /// event_name
        if responseDict.contains(Key: "event_name") {
            
            if let event_name = responseDict["event_name"] as? String {
                
                self.event_name = event_name
            }
            else {
                
                self.event_name = ""
            }
        }
        else {
            
            self.event_name = ""
        }
        
        /// user_fullname
        if responseDict.contains(Key: "user_fullname") {
            
            if let user_fullname = responseDict["user_fullname"] as? String {
                
                self.event_user_Name = user_fullname
            }
            else {
                
                self.event_user_Name = ""
            }
        }
        else {
            
            self.event_user_Name = ""
        }
        
        if (responseDict.contains(Key: "friend_invitees")) {
        
            if let inviteeArray = responseDict["friend_invitees"] as? NSArray {
            
                self.invitees = NSMutableArray(array: inviteeArray)
            }
            else {
            
                self.invitees = NSMutableArray()
            }
        }
        else {
        
            self.invitees = NSMutableArray()
        }
        
        if (responseDict.contains(Key: "user_picture")) {
            
            if let userPicture = responseDict["user_picture"] as? String {
                self.event_user_Pic = paths.Img_Base_Url+"users/"+userPicture
            }
            else {
            
                self.event_user_Pic = ""
            }
        }
        else {
            
            self.event_user_Pic = ""
        }
        
        if (responseDict.contains(Key: "event_picture")) {
        
            if let eventPic = responseDict["event_picture"] as? String {
                
                self.event_Picture = paths.Img_Base_Url+"events/"+eventPic
            }
            else {
            
                self.event_Picture = ""
            }
        }
        else {
        
            self.event_Picture = ""
        }
        
        
        ///
        if responseDict.contains(Key: "time") {
            
            if let time = responseDict["time"] as? String {
             
                let formatedTime = time.toDate("H:mm:ss.SSS")
                self.event_time = "\(formatedTime.toTimeString())"
            }
            else {
                
                self.event_time = ""
            }
        }
        else {
            
            self.event_time = ""
        }
        
        
        
        if responseDict.contains(Key: "date") {
            
            if let eventDate = responseDict["date"] as? String {
                //            date = eventDate
                
                let date = (eventDate).toDate("yyyy-MM-dd")
                self.event_date    = "\(date.toString())"
                
                let dateTime:String =  (responseDict["date"] as! String) + " " + (responseDict["time"] as! String)
                let dt = dateTime.toDate("yyyy-MM-dd H:mm:ss.SSS")
                
                self.eventDateTime    = dt
            }
            else {
                
                self.event_date = ""
                self.eventDateTime = nil
            }
        }
        
    }
    
    private init(eventId:Int, address:String, latitude:Double, longitude:Double, eventType:String, eventPic:String, eName:String, date:Date, time:Date) {
        
        self.event_id = eventId
        self.venue_address = address
        self.venue_late    = latitude
        self.venue_long    = longitude
        self.event_type    = eventType
//        self.event_Picture = nil
//        self.event_Picture = paths.Img_Base_Url+eventPic
        self.event_Picture = paths.Img_Base_Url+"events/"+eventPic
        self.event_name    = eName
        self.event_date    = "\(date.toString())"
        self.event_time    = "\(time.toTimeString())"
        self.eventDateTime    = date
        
    }
    
    
    private init(eventId:Int, address:String, latitude:Double, longitude:Double, eventType:String, eventPic:String, eName:String, date:Date, time:Date, dateTime:Date) {
        
        self.event_id = eventId
        self.venue_address = address
        self.venue_late    = latitude
        self.venue_long    = longitude
        self.event_type    = eventType
        //        self.event_Picture = nil
        //        self.event_Picture = paths.Img_Base_Url+eventPic
        self.event_Picture = paths.Img_Base_Url+"events/"+eventPic
        self.event_name    = eName
        self.event_date    = "\(date.toString())"
        self.event_time    = "\(time.toTimeString())"
        self.eventDateTime    = dateTime
        
    }
    
    
    private init(eventId:Int, eventName:String, eventPicture:String, friend_invitees:Array<AnyObject>, date: Date! = nil, time:Date, userFullname:String, userPicture: String, venueAddress: String, venueLate:Double, venueLong:Double, venueLocation:String) {
        
        self.event_id = eventId
        self.venue_address = venueAddress
        self.venue_late    = venueLate
        self.venue_long    = venueLong
        self.invitees = friend_invitees as! NSMutableArray
        self.event_user_Name = userFullname
        self.event_user_Pic = paths.Img_Base_Url+"users/"+userPicture
        //        self.event_Picture = nil
        //        self.event_Picture = paths.Img_Base_Url+eventPic
        self.event_Picture = paths.Img_Base_Url+"events/"+eventPicture
        self.event_name    = eventName
        self.eventDateTime    = date
        
        if date == nil {
            
            self.event_date = ""
        }
        else {
            
            self.event_date    = "\(date.toString())"
        }
        self.event_time    = "\(time.toTimeString())"
        
    }
}
