//
//  ModelConverter.swift
//  CatchUp
//
//  Created by aplome on 12/06/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class ModelConverter: NSObject {

    static func convertToFriends(fromFriendList friendList: FriendList) -> Friends {
    
        let friend = Friends(fid: friendList.friendId, fName: friendList.name!, fImage: friendList.thumPicture!, fgname: "", fgId: 0, isCatchupUser: friendList.isCatchupUser, fEmail: friendList.friendEmail!)
        
        return friend
    }
    
    static func convertToFriends(fromPhoneContactList phoneList: PhoneContactList) -> Friends {
    
        let friend = Friends(fid: phoneList.friendId, fName: phoneList.fullName!, fImage: "", fgname: "", fgId: 0, isCatchupUser: false, fEmail: phoneList.emailAddress!, fPhoneNumber: phoneList.contactNumber!)
        
        return friend
    }
}
