//
//  AppDelegate.swift
//  CatchUp
//
//  Created by Macbook on 12/20/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import MagicalRecord
import CoreData
import GoogleMaps
import GooglePlaces

//@available(iOS 10, *)
import UserNotifications;
import Fabric
import Crashlytics
import Firebase
import FirebaseDynamicLinks


enum FriendType: Int {
    case Email = 0, Mobile = 1
}

enum FriendControllerType: Int {
    case FriendsList = 0, InviteesList = 1
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Parameters
    var window: UIWindow?

    var eventsListArray : [Event] = []
    var contactsArray =  [[String:String]]()
    
    // MARK: - App Cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(constants.kAPIKey)
        GMSPlacesClient.provideAPIKey(constants.kAPIKey)
        
        Fabric.with([Crashlytics.self])
        
        FirebaseApp.configure()
        
        MagicalRecord.setupCoreDataStack(withStoreNamed: "CatchUp")
        
        //check user already logedin or not, unArchived saved user
        self.unArchiveUser()
        
        self.setupDefaultTheme()
        
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
        
        if UserDefaults.standard.bool(forKey: "isUserLoging") == true {
            self.contactsArray = CatchupContacts.sharedInstance.importContactsFromPhone()
            CatchupContacts.sharedInstance.uploadUserContactInDB(contactsArray: self.contactsArray, completion: { (success, responseDict) in
            })
        }

//        self.uploadUserContactInDB();

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        MagicalRecord.cleanUp()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
        MagicalRecord.setupCoreDataStack(withStoreNamed: "CatchUp")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

// MARK: - Helper Methods

extension AppDelegate {
    
    @nonobjc static var appDelegate = {
    
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
//    class func appDelegate() -> AppDelegate {
//        
//        return UIApplication.shared.delegate as! AppDelegate
//    }

    func initializeNotificationServices() {
        
        let application: UIApplication = UIApplication.shared
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
//        else if #available(iOS 8, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
    
    func setupDefaultTheme() {
        
        self.window?.tintColor = constants.getThemeTextColor()
        
        //Navigation bar tincolor and title color
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = constants.getThemeTextColor() //UIColor(red: 31.0/255.0, green: 151.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: constants.navbarFont, NSForegroundColorAttributeName:constants.getThemeTextColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: constants.barbuttonFont, NSForegroundColorAttributeName:constants.getThemeTextColor()], for: UIControlState.normal)
        
        //change Search bar text color
        let searchBarTextAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
    }
    
    func setLoginView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
        let nav = UINavigationController(rootViewController: initialViewController)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func setMainViewAfterLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "mapVc")
        let nav = UINavigationController(rootViewController: initialViewController)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func unArchiveUser() {
        Utitlity.sharedInstance.user_profile = constants.unArchiveUser()
        Utitlity.sharedInstance.updated_user_profile_Detail = Utitlity.sharedInstance.user_profile
    }
    
    func showEventDetailPage(withEventId eventId: String) {
    
        let eventDetailViewController: UINavigationController = Utitlity.getEventDetailViewController(WithEventID: String(eventId))
        
        
        let navigationVC: UINavigationController = self.window?.rootViewController as! UINavigationController
        
        navigationVC.present(eventDetailViewController, animated: true, completion: nil)
    }

    func addFriendToServerContacts(friend_id: String) {
    
        let params = [
            "user_id" : String(describing: Utitlity.sharedInstance.user_profile!.user_Id),
            "friend_id" : friend_id
        ]
        
        NetworkServices.sharedInstance.postWebServiceWith(paths.make_friend_each, params: params as [String : AnyObject], headers: [:]) { (isSuccess, responseDict) in
            
            if isSuccess {
            
                print(responseDict)
                
                let message: String = responseDict["message"] as! String
                
                Utitlity.sharedInstance.showAlert((self.window?.rootViewController)!, message: message, completion: { (alertAction) in
                    
                    
                })
            }
            else {
            
            }
        }
    }

    //user_id:34 event_id:20 invitee_id:[{"friend_id":"6"},{"friend_id":"7"}]
    
    func saveEventInviteesToServer(event_id: String) {
    
        let dict: [String: AnyObject] = ["friend_id":1 as AnyObject]
        let params = [
            "user_id" : String(describing: Utitlity.sharedInstance.user_profile!.user_Id),
            "event_id" : event_id,
            "invitee_id" : [dict]
        ] as [String : AnyObject]
        
        NetworkServices.sharedInstance.postWebServiceWith(paths.save_event_invitees, params: params, headers: [:]) { (isSuccess, responseDict) in
            
            if isSuccess {
                
                print(responseDict)
                
//                let message: String = responseDict["message"] as! String
//                
//                Utitlity.sharedInstance.showAlert((self.window?.rootViewController)!, message: message, completion: { (alertAction) in
//                    
//                    
//                })
            }
            else {
                
            }
        }
    }
}


 // MARK: - FIREBASE

extension AppDelegate {

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return application(app, open: url, sourceApplication: nil, annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url)
        if let dynamicLink = dynamicLink {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            if dynamicLink.url != nil {
                self.showDynamicLinkMessage(dynamicLink)
            }
        }
        
        return true
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let dynamicLinks = DynamicLinks.dynamicLinks() else {
            return false
        }
        let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            
            if dynamiclink?.url != nil {
            
                self.showDynamicLinkMessage(dynamiclink!)
                
                
                // https://www.catchup.com/Invitation/Friend/18
                print("URL: \(String(describing: (dynamiclink?.url)) )")
                
                // /Invitation/Friend/18
                print("Path: \(String((dynamiclink?.url?.path)!) ?? "")")
            }
        }
        
        
        return handled
    }
    
    
    func showDynamicLinkMessage(_ dynamicLink: DynamicLink) {
    
       // let linkPath: String = dynamicLink.url?.absoluteString ?? default ""
        let linkPath: String = (dynamicLink.url?.absoluteString)!
        let newString = linkPath.replacingOccurrences(of: constants.FIREBASE_APPLINK, with: "")
        let linkPathArray: [String] = newString.components(separatedBy: "/")
        
        /// Indexes:     0/1/2
        /// Example:      /Category/CategoryType/CategoryLink
        /// Working Link: /Invitation/Event/203
        /// Working Link: /Invitation/Friend/203
        
        if linkPathArray.count == 3 {
            
            if UserDefaults.standard.bool(forKey: "isUserLoging") == true {
            let category: String = linkPathArray[0]
            let categoryType: String = linkPathArray[1]
            let categoryLink: String = linkPathArray[2]
            
            if category == "Invitation" {
            
                if categoryType == "Friend" {
                    
                    self.addFriendToServerContacts(friend_id: categoryLink)
                }
                else if categoryType == "Event" {
                    
                    self.saveEventInviteesToServer(event_id: categoryLink)
                    self.showEventDetailPage(withEventId: categoryLink)
                }
            }
            }
            else{
                UserDefaults.standard.set(newString, forKey: "dynamiclink")
            }
        }
    }
}

    // MARK: - Notifications
extension AppDelegate {
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
        if deviceToken.count < 1
        {
            Utitlity.sharedInstance.device_token = "ABCDEFGTHI"
        }
        else{
            Utitlity.sharedInstance.device_token = deviceTokenString     
        }
        
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        if(application.applicationState == .active) {
            
            //app is currently active, can update badges count here
            
        }else if(application.applicationState == .background){
            
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            
        }else if(application.applicationState == .inactive){
            
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
         
            let aps: [String: Any] = data["aps"] as! [String : Any];
            
            
            if aps.contains(Key: "event_id") {
                
                let event_Id = aps["event_id"] as! String

                
                print(event_Id)
                
                self.showEventDetailPage(withEventId: event_Id)
                
                //            navigationVC.pushViewController(eventDetailViewController, animated: true)
                
                //        if navigationVC.viewControllers.count > 0 {
                //
                //            let vc: UIViewController = navigationVC.viewControllers[0]
                //
                //            vc.present(eventDetailViewController, animated: true, completion: nil)
                //        }
                
                
                /*devicetoken
                 
                 let tabController: MainTabBarController = self.parent.window?.rootViewController as! MainTabBarController
                 
                 let baseNavigationViewController: BaseNavigationController = tabController.selectedViewController as! BaseNavigationController
                 
                 print(baseNavigationViewController.visibleViewController as Any)
                 
                 
                 
                 if (baseNavigationViewController.visibleViewController?.isKind(of: ChatScreenViewController.self))! {
                 
                 */
            }
            else {
            
                
            }
        }
    }
    /*
     
     Push notification received: [AnyHashable("aps"): {
     alert = "nasir mehboob send you an invite for testing";
     badge = 1;
     "event_id" = 122;
     sound = "bingbong.aiff";
     }]

     
     */
    
}

