//
//  HandleResponse.swift
//  CatchUp
//
//  Created by aplome on 12/06/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import MagicalRecord
import CoreData

class HandleResponse: NSObject {

    
    static func saveContactsInDB(phoneContacts: [[String: String]]) {
        
        let contactsList: [[String: String]] = phoneContacts.reversed()
        
        HandleResponse.savePhoneContactListInDB(contactsList)
    }
    
    static func handleFriendListRespone(_ response: AnyObject) {
        
        FriendList.mr_truncateAll()
        
        for friendDict in response as! [[String: Any]] {
            
            
            let boolValue = (friendDict["is_user"] as! String).toBool()
            
//            if boolValue {
            
            let friendList = FriendList.mr_createEntity()
            
            var picture : String = ""
            
            if let pic = friendDict["thum_picture"] as? String {
                picture = pic
            }
            
            friendList?.isCatchupUser = boolValue
            friendList?.friendId = Int64(friendDict["friend_id"] as! Int64)
            friendList?.name = friendDict["name"] as? String
            friendList?.friendEmail = friendDict["email"] as? String
            friendList?.thumPicture = picture
//            }
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    static func savePhoneContactListInDB(from friendsList: NSMutableArray) {
    
        PhoneContactList.mr_truncateAll()
        
        for contactFriend in friendsList {
            
            let friend: Friends = contactFriend as! Friends
            
            let phoneContact = PhoneContactList.mr_createEntity()
            
            phoneContact?.friendId = Int64(friend.friend_id)
            phoneContact?.fullName = friend.friend_name;
            
            phoneContact?.contactNumber = friend.friend_phoneNumber
            phoneContact?.emailAddress = friend.friend_email
            phoneContact?.isCatchupUser = friend.friend_isCatchupUser
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    static func savePhoneContactListInDB(_ contactList: [[String: String]]) {
        
        PhoneContactList.mr_truncateAll()
        
        for contactDict in contactList {
            
            if contactDict["email"] == "" {
            
                let phoneContact = PhoneContactList.mr_createEntity()
                
                phoneContact?.friendId = Int64(0)
                phoneContact?.fullName = contactDict["fname"]! + " " + contactDict["lname"]!;
                
                phoneContact?.contactNumber = contactDict["phoneNumber"]
                phoneContact?.emailAddress = contactDict["email"]
                phoneContact?.isCatchupUser = false
            }
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
}
