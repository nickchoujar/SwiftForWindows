//
//  DynamicLinkUtility.swift
//  CatchUp
//
//  Created by aplome on 17/08/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks
import MessageUI

public typealias DynamicLinkURLCompletion = (URL?, String?, Error?) -> Swift.Void

class DynamicLinkUtility: NSObject {

    /// get the parameters of dynamic link for ios
    ///
    /// - Returns: return the ios parameters object
    
    static func getiOSParams() -> DynamicLinkIOSParameters {
        
        let bundle = Bundle.main.bundleIdentifier;
        let iOSParams = DynamicLinkIOSParameters(bundleID: bundle!)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            iOSParams.minimumAppVersion = version
        }
        
        iOSParams.appStoreID = constants.FIREBASE_APPSTOREID
        iOSParams.customScheme = ""
        iOSParams.fallbackURL = URL(string: constants.FIREBASE_APPLINK)
        iOSParams.iPadBundleID = bundle
        iOSParams.iPadFallbackURL = URL(string: constants.FIREBASE_APPLINK)
        
        
        return iOSParams
    }
    
    
    /// get the parameters of dynamic links for android
    ///
    /// - Returns: return the android parameters object
    
    static func getAndroidParams() -> DynamicLinkAndroidParameters {
        
        /// name of the android app package
        let packageName = "catchupAndroid"
        
        /// parameter value
        let androidParams = DynamicLinkAndroidParameters(packageName: packageName)
        androidParams.fallbackURL = URL(string: "")
        androidParams.minimumVersion = 1;
        
        return androidParams
    }
    
    
    /// get dynamic link url string for user
    ///
    /// - Parameters:
    ///   - path: url path of deeplink for appending with base url 'constants.FIREBASE_APPLINK'
    ///   - completion: block completion returns dynamic link url string
    
    static func getDynamiclink(withPath path: String, completion:@escaping DynamicLinkShortenerCompletion) {
        
        /// firebase domain url string
        let domain = constants.FIREBASE_DOMAIN //"xxxxx.app.goo.gl"
        
        let baseUrlString = constants.FIREBASE_APPLINK
        
        let fulURLString =  baseUrlString + path
        
        let deeplinkURL = URL(string: fulURLString)
        
        if deeplinkURL != nil {
            
            /// create dynamic link compoment
            let components = DynamicLinkComponents(link: deeplinkURL!, domain: domain)
            
            components.iOSParameters = self.getiOSParams()
            //        components.androidParameters = self.getAndroidParams()
            
            //        let longLink: URL = components.url!
            //        print(longLink.absoluteString )
            
            let options = DynamicLinkComponentsOptions()
            
            /// set path length for dynamic link url short or unguessable
            options.pathLength = .short
            components.options = options
            
            components.shorten { (shortURL, warnings, error) in
                
                completion(shortURL, warnings, error)
            }
        }
    }
    
    
    /// Create dynamic link for invite friends
    ///
    /// - Parameters:
    ///   - friendId: friends unique id
    ///   - completion: block for return url path.
    
    static func getDynamicLinkForFriend(withFriendId friendId: String, completion: @escaping DynamicLinkURLCompletion) {
    
        let path: String = "Invitation/Friend/" + friendId
        
        self.getDynamiclink(withPath: path) { (shortUrl, warning, error) in
            
            completion(shortUrl, shortUrl?.absoluteString, error)
        }
    }
    
    
    /// Create dynamic link for invited friend in event who's not catchup user yet.
    ///
    /// - Parameters:
    ///   - eventId: created event unique id.
    ///   - completion: block returns url path.
    
    static func getDynamicLinkForEvent(withEventId eventId: String, completion: @escaping DynamicLinkURLCompletion) {
        
        let path: String = "Invitation/Event/" + eventId
        
        self.getDynamiclink(withPath: path) { (shortUrl, warning, error) in
            
            completion(shortUrl, shortUrl?.absoluteString, error)
        }
    }
    
    /// Send SMS to friends for app event invitations. Event invitation add invitees_Array and set createdEventId in Utiltiy
    ///
    /// - Parameters:
    ///   - eventId: Created Event's Id for event detail
    ///   - target: Present default SMS controller to this target controller
    static func inviteFriendsViaSMS(withEventId eventId: String = "", onTarget target: AnyObject) {
    
        let friendList: NSMutableArray = Utitlity.sharedInstance.contacts_Array
        
        if friendList.count > 0 {
            
            if eventId != "" {
                
                /// Event Invitation via SMS only for Contacts
                Utitlity.sharedInstance.createdEventId = eventId
                
                /// Shows event invitation SMS
                self.inviteFriendsForEvent(onTarget: target)
            }
            else {
            
                /// Shows installation invitation SMS
                self.inviteFriendsForCatchUp(onTarget: target)
            }
        }
    }
    

    /// Invite friends for events
    ///
    /// - Parameter target: Presented controller
    static private func inviteFriendsForEvent(onTarget target: AnyObject) {
        
        let eventId: String = Utitlity.sharedInstance.createdEventId
        
        if eventId != "" {
            
            let friendName: String = (Utitlity.sharedInstance.user_profile?.user_name)!.capitalized
            
            let phoneNumberList: [String] = self.getPhoneNumberFromInviteeDictionary()
            
            Utitlity.sharedInstance.showProgressHud()
            
            self.getDynamicLinkForEvent(withEventId: eventId) { (shortUrl, shortUrlString, error) in
                
                Utitlity.sharedInstance.hideProgressHud()
                
                let urlString: String = (shortUrlString != "") ? shortUrlString! : constants.FIREBASE_APPLINK
                
                let body = "\(friendName) has invited you for an Event. Please check this: \(urlString)"
                
                self.showMessageViewController(onTarget: target, recipients: phoneNumberList, body: body)
            }
        }
    }
    
    
    /// Invite friends for CatchUp
    ///
    /// - Parameter target: Presented controller
    static private func inviteFriendsForCatchUp(onTarget target: AnyObject) {
    
        let friendId: String = String(Utitlity.sharedInstance.user_profile!.user_Id)
        
        let friendName: String = (Utitlity.sharedInstance.user_profile?.user_name)!.capitalized
        
        let phoneNumberList: [String] = self.getPhoneNumberFromFriendDictionary()
        
        Utitlity.sharedInstance.showProgressHud()
        
        self.getDynamicLinkForFriend(withFriendId: friendId) { (shortUrl, shortUrlString, error) in
            
            Utitlity.sharedInstance.hideProgressHud()
            
            let urlString: String = (shortUrlString != "") ? shortUrlString! : constants.FIREBASE_APPLINK
            
            let body = "\(friendName) has invited you to CatchUp. Please install to connect: \(urlString)"

            DispatchQueue.main.async {
                () -> Void in
                
                self.showMessageViewController(onTarget: target, recipients: phoneNumberList, body: body)
            }
        }
    }
    
    
    /// Compose message for app event/install invitation
    ///
    /// - Parameters:
    ///   - target: Presented Controller
    ///   - recipients: List of contact numbers for composing message
    ///   - body: Message body for composing message
    static private func showMessageViewController(onTarget target: AnyObject, recipients: [String], body: String) {
    
        let composeVC = MFMessageComposeViewController()
        
        if target.isKind(of: CreateActivityViewController.self) {
        
            composeVC.messageComposeDelegate = target as! CreateActivityViewController
        }
        else if target.isKind(of: FriendsViewController.self) {
        
            composeVC.messageComposeDelegate = target as! FriendsViewController
        }
        
        // Configure the fields of the interface.
        composeVC.recipients = recipients
        composeVC.body = body
        
        target.present(composeVC, animated: true, completion: nil)
    }
    
    
    /// Get contact numbers from contact dictionarie's array
    ///
    /// - Returns: List of contact numbers
    static private func getPhoneNumberFromFriendDictionary() -> [String] {
        
        let phoneContactsList: NSMutableArray = Utitlity.sharedInstance.contacts_Array
        
        var resultNumbersList: [String] = [String]()
        
        for contactDict in phoneContactsList {
            
            let contact = contactDict as! [String: String]
            
            resultNumbersList.append(contact["friend_Number"]!)
        }
        
        return resultNumbersList
    }
    
    /// Get contact numbers from contact dictionarie's array
    ///
    /// - Returns: List of contact numbers
    static private func getPhoneNumberFromInviteeDictionary() -> [String] {
        
        let phoneContactsList: NSMutableArray = Utitlity.sharedInstance.contacts_Array
        
        var resultNumbersList: [String] = [String]()
        
        for contactDict in phoneContactsList {
            
            let contact: Friends = contactDict as! Friends
            
            resultNumbersList.append(contact.friend_phoneNumber)
        }
        
        return resultNumbersList
    }
    
}
