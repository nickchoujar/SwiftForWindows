//
//  Constants.swift
//  CatchUp
//
//  Created by Macbook on 12/21/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import Foundation
import SVProgressHUD
import CoreLocation

struct constants {
    
    static let kAPIKey = "AIzaSyDIeVsWunxBDhCnj72iTPfqJdGXeAARAU8"
//    static let kAPIKey = "AIzaSyBRkSrmL_K83TMEU-iM5qfGyQzd9AhAleo"
    
    static let FIREBASE_DOMAIN = "sa6f4.app.goo.gl"
    static let FIREBASE_APPLINK = "https://itunes.apple.com/au/app/catchup/id1244153836?mt=8"
    static let FIREBASE_APPSTOREID = "1244153836"
    
    static let wrong_usernameorPassword_message = "Your username/password do not match"
    static let Invalid_Username = "Invalid Username"
    static let Invalid_Email = "Invalid Email"
    static let Invalid_Password = "Invalid Password"
    static let ALERT_TITLE = "CatchUp"
    static let Incorrect_Email_Formate = "Please Enter Valid Email ex(catchup@gmail.com)"
    static let check_Email_Message     = "Check your email account, follow the instructions that we've sent to your email address."
    static let email_Not_Exist = "This email doesnot exist in our database please provide valid email ID."
    static let password_DoNot_match = "New password and confirm password do not match"
    static let AllFieldsRequired    = "All fields are required"
    
    static let validationEmailRequired    = "Please enter email address"
    static let validationNameRequired    = "Please enter Name"
    
    //MARK :- navigation bar text font 
   static let navbarFont = UIFont(name: "Myriad Pro Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
   static let barbuttonFont = UIFont(name: "Myriad Pro Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
    
    
    //MARK:-  Functions
   static func archiveUser(_ user:User?) {
        // first we need to convert our  custom User objects to a NSData blob, as NSUserDefaults cannot handle custom objects. It is limited to NSString, NSNumber, NSDate, NSArray, NSData. There are also some convenience methods like setBool, setInteger, ... but of course no convenience method for a custom object
            // note that NSKeyedArchiver will iterate over the 'user' object. So 'encodeWithCoder' will be called for each object  (see the print statements)
        if let user = user {
            let dataBlob = NSKeyedArchiver.archivedData(withRootObject: user)
        
            // now we store the NSData blob in the user defaults
            UserDefaults.standard.set(dataBlob, forKey: "loginUserInUserDefaults")
        
            // make sure we save/sync before loading again
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getThemeTextColor() -> UIColor {
    
        return UIColor(red: 31.0/255.0, green: 151.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    }
    
    static func getThemeTextFieldColor() -> UIColor {
        
        return UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    
    static func getThemeBackgroundColor() -> UIColor {
        
        return UIColor(red: 46.0/255.0, green: 60.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    }
    
    static func getThemeForegroundColor() -> UIColor {
        
        return UIColor(red: 30.0/255.0, green: 147.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    }
    
    static func unArchiveUser()->User?{
        // now do everything in reverse :
        //
        // - first get the NSData blob back from the user defaults.
        // - then try to convert it to an NSData blob (this is the 'as? NSData' part in the first guard statement)
        // - then use the NSKeydedUnarchiver to decode each custom object in the NSData object. This again will generate a call to 'init?(coder aDecoder)' for each element in the array
        // - and when that succeeded try to convert this NSData to an User
        guard let decodedNSDataBlob = UserDefaults.standard.object(forKey: "loginUserInUserDefaults") as? NSData,
            let loadedPlayersFromUserDefault = NSKeyedUnarchiver.unarchiveObject(with: decodedNSDataBlob as Data) as? User
            else {
                return nil
        }
        
        return loadedPlayersFromUserDefault
    }
}

struct paths {
    static let Base_Url = "http://catchuptest.azurewebsites.net/index.php/web_services/app_services/"
    static let Img_Base_Url = "http://catchuptest.azurewebsites.net/uploads/"
    static let user_register = "register"
    static let user_login = "login"
    static let forgot_password = "forgot_password"
    static let reset_Password = "rest_password"
    static let update_password = "update_password"
    static let user_friend = "user_friend"
    static let user_friends_list = "friends_list"
    static let user_friend_profile = "friend_profile"
    static let user_profile = "profile"
    static let user_profile_update = "update_profile"
    static let user_friend_invitee = "friends_invites"
    static let add_new_event = "add_event"
    static let event_detail = "single_event"
    static let user_friend_scheduel = "friends_sechduel"
    static let user_friends_list_gb = "friends_invites_gp"
    
    static let all_public_evnets = "public_events"
    static let delete_friend = "delete_friend"
    static let user_friend_detail = "frirnds_secdule"
    static let user_friend_profile_update = "update_fr_profile"
    static let user_Events = "user_events"
    static let date_Events = "date_events"
    static let user_contacts = "user_contacts"
    static let delete_user_account = "delete_user_account"
    
    static let send_invites = "send_invites"
    static let make_friend_each = "makeFriendEach"
    static let save_event_invitees = "saveEventInvitees"
    static let user_event_history = "historyEvents"

    // public
    static let user_venue_events = "user_venue_events"
    // private
    static let my_current_events = "myCurrentEvents"
}

class Utitlity : NSObject {
    static let sharedInstance = Utitlity()
    
    fileprivate override init() {
        
    }
    
    var user_profile : User?
    var updated_user_profile_Detail : User?
    var updated_friend_detail : Friend_Detail?
    
    var contacts_Array : NSMutableArray = []
    var invitees_Array : NSMutableArray = []
    var createdEventId : String = ""
    
    var schedules_Array : NSMutableArray = []
    var selected_location : NearestLocation?
    var user_current_location = CLLocation()
    var user_selected_location = CLLocation()
    var device_token : String? = ""

    func showProgressHud() {
        SVProgressHUD.show(withStatus: "Please wait")
    }

    func showProgressHud(message:String) {
        SVProgressHUD.show(withStatus: message)
    }

    func hideProgressHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func getMainStoryboard() -> UIStoryboard {
    
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func setRootView(_ vc:UIViewController) -> UINavigationController {
        let nav   = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor = UIColor.black
        nav.navigationBar.tintColor = constants.getThemeTextColor()
        nav.navigationBar.titleTextAttributes = [NSFontAttributeName: constants.navbarFont, NSForegroundColorAttributeName:constants.getThemeTextColor()]
        return nav
    }
    
    static func getEventDetailViewController(WithEventID eventID: String) -> UINavigationController {
    
        let eventDetailViewController: EventDetailViewController = self.getMainStoryboard().instantiateViewController(withIdentifier: "event_DetailVC") as! EventDetailViewController
        
        eventDetailViewController.selectedEventID = eventID

//        let nv: UINavigationController = UINavigationController(rootViewController: eventDetailViewController)
        
        return self.setRootView(eventDetailViewController)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        let loginViewController: LoginViewController = CommonsUI.getMainStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        
//        appDelegate.window?.rootViewController = loginViewController
//        
    }
    
    static func getContactsTuple(contacts: [[String:String]]) -> (emailContacts: [[String:String]], numberContacts: [[String:String]]) {
        
        
        var resultEmailed: [[String:String]] = []
        var resultNumbers: [[String:String]] = []
        
        for contactDict in contacts {
           // for contactDict in contacts {
            
            
            if contactDict["email"] != "" {
                
                if((contactDict["email"]?.characters.count)! < 35 ){
                   resultEmailed.append(contactDict)
                }
            }
            else if contactDict["number"] != "" {
                
                resultNumbers.append(contactDict)
            }
        }
        
        return (resultEmailed, resultNumbers)
    }
    
    func showAlert(_ alertController:UIViewController, message:String) {
        let alert  = UIAlertController.init(title: constants.ALERT_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        
        alertController.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ alertController:UIViewController, message:String, completion: @escaping(_ alertAction: UIAlertAction)->()) {
        
        let alert  = UIAlertController.init(title: constants.ALERT_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
        
            completion(alertAction)
        }
        
        alert.addAction(defaultAction)
        
        alertController.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ alertController:UIViewController, message:String, confirmActionTitle: String = "OK", cancelActionTitle: String = "Cancel", confirmActionStyle: UIAlertActionStyle = .default, cancelActionStyle: UIAlertActionStyle = .default, confirmAction: @escaping(_ alertAction: UIAlertAction)->(), cancelAction: @escaping(_ cancelAlertAction: UIAlertAction)->()) {
        
        let alert  = UIAlertController.init(title: constants.ALERT_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: confirmActionStyle) { (alertAction) in
            
            confirmAction(alertAction)
        }
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: cancelActionStyle) { (alertAction) in
            
            cancelAction(alertAction)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        alertController.present(alert, animated: true, completion: nil)
    }
    
    static func setLastLogoutPressed(_ logout: Bool) {
        
        let defaults = UserDefaults.standard
        defaults.set(logout, forKey: "lastLogoutPressed")
        defaults.synchronize()
    }
    
    static func  getLastLogoutPressed() -> Bool {
        let defaults = UserDefaults.standard
        if(defaults.value(forKey: "lastLogoutPressed") != nil){
            return defaults.bool(forKey: "lastLogoutPressed")
        }
        else{
            return false
        }
    }
}

//BACK Bar button with out text
extension UIBarButtonItem {
    class func backButton(_ colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x:0, y:0, width:10.0, height:15.0)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}

