//
//  FriendsViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/27/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import MagicalRecord
import CoreData
import Contacts
import AddressBook
import MessageUI

protocol InviteesFriendsViewDelegate {
    
    func selected(friends: NSArray)
}
class FriendsViewController: UITableViewController , MFMessageComposeViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet var rightBarButton: UIButton!
    @IBOutlet weak var friendsSegment: UISegmentedControl!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tblFriends_List : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    
    var delegate: InviteesFriendsViewDelegate!
    
    var friends_list_Array : NSMutableArray = []
    var friends_list_Array_temp : NSMutableArray = []
    var contactsArray =  [[String:String]]()
    var fullContactListfromDevice =  [[String:String]]()

    
    var controllerType: FriendControllerType = FriendControllerType.FriendsList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsSegment.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        self.tblFriends_List.tableFooterView = UIView();
        self.getContacts(forIndex: self.friendsSegment.selectedSegmentIndex)
        
        switch self.controllerType {
            
        case .FriendsList:
            Utitlity.sharedInstance.contacts_Array = []
            self.setupFriendsListController()
            break
        case .InviteesList:
            self.setupInviteesListController()
            break
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch self.controllerType {
        case .FriendsList:
            Utitlity.sharedInstance.contacts_Array = []
            break
            
        case .InviteesList:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Mark :- TableView Delegate and Datasource Methods.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends_list_Array_temp.count
      //  return contactsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as! FriendsTableViewCell
        
        let friend = friends_list_Array_temp[indexPath.row] as! Friends
       
        cell.delegate = self;
        
        switch self.controllerType {
        case .FriendsList:
            cell.configureFriendsCell(friend, controllerType: self.controllerType)
            break
            
        case .InviteesList:
            
            let friendType: FriendType = FriendType(rawValue: self.friendsSegment.selectedSegmentIndex)!
            switch friendType {
            case .Email:
                cell.configureInviteesCell(friend, controllerType: self.controllerType)
                break
            case .Mobile:
                cell.configureInviteesCellForPhoneNumbers(friend, btnTitle: "Invite via SMS", controllerType: self.controllerType)
                
                break
            }
            
            break
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
 
        let friend = friends_list_Array_temp[indexPath.row] as! Friends
        
        switch self.controllerType {
        case .FriendsList:
            self.didFriendSelectPressed(friend)
            break
            
        case .InviteesList:
            self.inviteeSelectPressed(friend)
            break
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.

        switch self.controllerType {
        case .FriendsList:
            return true
        case .InviteesList:
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch self.controllerType {
        case .FriendsList:
            
            if editingStyle == .delete {
                // Delete the row from the data source
                let friend = friends_list_Array_temp[indexPath.row] as! Friends
                self.deleteFriend(friend_id:friend.friend_id)
                friends_list_Array_temp.removeObject(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
            
            break
        case .InviteesList:
            break
        }
    }
}

// MARK: - FriendsTableViewCellDelegate

extension FriendsViewController: FriendsTableViewCellDelegate {
    
    func friendsTableViewCell(_ cell: FriendsTableViewCell, friend: Friends) {

        switch self.controllerType {
        case .FriendsList:
            self.setContactsArray(value: friend.friend_phoneNumber, forKey: "friend_Number")
            break
        case .InviteesList:
            if(friend.friend_id == 0){
                self.setContactsArray(value: String(friend.friend_phoneNumber), forKey: "friend_phoneNumber")
            }
            else{
                self.setContactsArray(value: String(friend.friend_id), forKey: "friend_id")
            }
//            self.setContactsArray(value: friend.friend_phoneNumber, forKey: "friend_Number")

            break
        }
        
//        let pred = NSPredicate(format: "friend_id == %@", argumentArray: [friend_Id])
//        let filterArr = Utitlity.sharedInstance.contacts_Array.filtered(using: pred)
//        let dict = ["friend_id":friend_Id]
//        if filterArr.count>0 {
//            Utitlity.sharedInstance.contacts_Array.remove(dict)
//        }else{
//            Utitlity.sharedInstance.contacts_Array.add(dict)
//        }
//        tblFriends_List.reloadData()
    }
    
    func setContactsArray(value: String, forKey key: String) {
        
        let pred = NSPredicate(format: "\(key) == %@", argumentArray: [value])
        
        let filterArr = Utitlity.sharedInstance.contacts_Array.filtered(using: pred)
        let dict = [key:value]
        
        
        if filterArr.count>0 {
            Utitlity.sharedInstance.contacts_Array.remove(dict)
        }else{
            Utitlity.sharedInstance.contacts_Array.add(dict)
        }
        
        tblFriends_List.reloadData()
    }
}

// MARK: - Segment change value
extension FriendsViewController {
    
    @IBAction func didChangeSegmentValue(_ sender: UISegmentedControl) {
        
        self.getContacts(forIndex: sender.selectedSegmentIndex)
    }
    
}
// MARK: -


extension FriendsViewController {
    
    
    // MARK: -  Right bar button pressed
    
    @IBAction func didRightButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            self.performSegue(withIdentifier: "FriendDetailSegue", sender: nil)
        }
        else {
            
            if Utitlity.sharedInstance.contacts_Array.count > 0 {
                DynamicLinkUtility.inviteFriendsViaSMS(onTarget: self)
                
                print("\(Utitlity.sharedInstance.contacts_Array.count) Invitees are selected")
            }
            else {
                
                Utitlity.sharedInstance.showAlert(self, message: "Please select atleast one contact for send Invitation via SMS")
                
                print("Invitees are not selected")
            }
        }
    }
    
    
    
    func setRightBarButton(forContacts isContacts: Bool = true) {
        
        let buttonTitle = (isContacts) ? "Send" : ""
        let buttonImage = (isContacts) ? nil : UIImage(named: "add_icon")
        let buttonTag = (isContacts) ? 1 : 0
        
        var frame: CGRect = self.rightBarButton.frame
        
        frame = (isContacts) ? CGRect(x: frame.origin.x, y: frame.origin.y, width: 50, height: 20) : CGRect(x: frame.origin.x, y: frame.origin.y, width: 20, height: 20)
        
        self.rightBarButton.frame = frame
        
        self.rightBarButton.setImage(buttonImage, for: .normal)
        self.rightBarButton.setTitle(buttonTitle, for: .normal)
        self.rightBarButton.tag = buttonTag
    }
    
    // Mark: Get Contacts
    
    
    func getContacts(forIndex selectedSegmentIndex: Int) {
        
        let friendType: FriendType = FriendType(rawValue: selectedSegmentIndex)!
        
        switch self.controllerType {
        case .FriendsList:
            self.getContacts(forType: friendType)
            break
        case .InviteesList:
            self.getContacts(forType: friendType, isInvitees: true)
            break
        }
    }

    
    func getContacts(forType friendType: FriendType, isInvitees: Bool = false) {
    
        switch friendType {
        case .Email:
            if !isInvitees {
                self.setRightBarButton(forContacts: false)
            }
            
            self.friends_list_Array = Friends.getAllFriendsList()
            self.friends_list_Array_temp = Friends.getAllFriendsList()
            break
            
        case .Mobile:
            
            if !isInvitees {
                self.setRightBarButton()
            }

            self.friends_list_Array = Friends.getMobileOnlyContacts(contacts: self.fullContactListfromDevice)
            self.friends_list_Array_temp = Friends.getMobileOnlyContacts(contacts: self.fullContactListfromDevice)
            
            break
        }
        
        
        self.friends_list_Array.sort(using: [NSSortDescriptor(key: "friend_name", ascending: true, selector:#selector(NSString.caseInsensitiveCompare(_:)))])
        self.friends_list_Array_temp.sort(using: [NSSortDescriptor(key: "friend_name", ascending: true, selector:#selector(NSString.caseInsensitiveCompare(_:)))])

        self.tblFriends_List.reloadData()
    }
    
    
    // Mark: - Get Contacts
    
    func deleteFriend(friend_id: Int64) {
        let param = ["friend_id":String(friend_id)]
        NetworkServices.sharedInstance.postWebServiceWith(paths.delete_friend, params: param as [String:AnyObject], headers: [:], completion:
            {(success,responseDict) in
                if success {
                    
                }else{
                    Utitlity.sharedInstance.showAlert(self, message: "Request do not complete due to some server error.")
                }
        })
    }
    
}

extension FriendsViewController {
    
    func updateContactsList() {
        
        let frientList: NSMutableArray = Friends.getAllFriendsList()
        let contactsList: NSMutableArray = Friends.getPhoneContactsList()
        
        let resultContactList: NSMutableArray = NSMutableArray()
        
        for friendDB in frientList {
            
            let friend: Friends = friendDB as! Friends
            
            for contactDB in contactsList {
                
                let contact: Friends = contactDB as! Friends
                
                if friend.friend_name == contact.friend_name {
                    
                    contact.friend_id = friend.friend_id
                    contact.friend_isCatchupUser = friend.friend_isCatchupUser
                    resultContactList.add(contact)
                }
            }
        }
        
        //HandleResponse.savePhoneContactListInDB(from: resultContactList)
        
    }
    
    
    func uploadUserContactInDB() {
        
//        getFriendsListFromServer()
        
        if(self.friends_list_Array.count < 1){
            Utitlity.sharedInstance.showProgressHud(message: "Syncing your contact list, Please wait")
        }
        
        if contactsArray.count > 0 {
         
            CatchupContacts.sharedInstance.uploadUserContactInDB(contactsArray: self.contactsArray, completion: { (success, responseDict) in
        
                self.getFriendsListFromServer()
            })
        }
        else {
            
            self.getFriendsListFromServer()
        }
        
        
//        if contactsArray.count > 0 {
//
//            HandleResponse.saveContactsInDB(phoneContacts: contactsArray)
//            
//            let result = Utitlity.getContactsTuple(contacts: self.contactsArray)
//            
//            let emailContacts: [[String:String]] = result.emailContacts
//            //        let numberContacts: [[String:String]] = result.numberContacts
//            
//            if emailContacts.count > 0 {
//                
//                let emailContactList: [[String: String]] = emailContacts.reversed()
//                
//                //                        Utitlity.sharedInstance.showProgressHud()
//                
//                let params = ["contact_list":["user_id":String(describing: Utitlity.sharedInstance.user_profile!.user_Id),
//                                              "contact_list":emailContactList]] as [String : Any]
//                
//                NetworkServices.sharedInstance.postContactsWebServiceWith(paths.user_contacts, params:params as [String : AnyObject], headers: [:]) { (success, responseDict) in
//                    
//                    
//                    print(responseDict)
//                    if(success){
//                        print("Contact added")
//                        self.getFriendsListFromServer()
//                    }
//                    else{
//                        
//                    }
//                    
//                    //            Utitlity.sharedInstance.hideProgressHud()
//                }
//            }
//        }
//        else {
//        
//            self.getFriendsListFromServer()
//        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        Utitlity.sharedInstance.contacts_Array = []
        self.tblFriends_List.reloadData()
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}



// MARK: - Friends List View Controller

extension FriendsViewController {

    fileprivate func setupFriendsListController() {
    
        self.navigationItem.title = "Friends"
        //Side bar menu setting
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsViewController.getFriendsListFromServer), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
        //load friends list from Server
        self.contactsArray = CatchupContacts.sharedInstance.importContactsFromPhone()
        self.fullContactListfromDevice = CatchupContacts.sharedInstance.importContactsFromPhone()
        self.uploadUserContactInDB();
    }
    
    @objc fileprivate func getFriendsListFromServer() {
        
     //   Utitlity.sharedInstance.showProgressHud()
        if self.friends_list_Array.count > 0 {
            
        }
        else {
            
        }
        
        let params = [
            "user_id":String(describing: Utitlity.sharedInstance.user_profile!.user_Id)
        ]
        
        if(self.friends_list_Array.count < 1){
            Utitlity.sharedInstance.showProgressHud(message: "Almost done ...")
        }

        
        NetworkServices.sharedInstance.postWebServiceWith(paths.user_friends_list, params: params as [String : AnyObject], headers: [:], completion:
            {(success,responseDict) in
                if success {
                    let dataArray = responseDict["data"]
                    if (dataArray?.count)!>0 {
                        
                        HandleResponse.handleFriendListRespone(dataArray!)
                        
//                        self.updateContactsList()
                        
                        self.getContacts(forIndex: self.friendsSegment.selectedSegmentIndex)
                    }
                    
                }else{
                    
                }
                
                Utitlity.sharedInstance.hideProgressHud()
        })
    }
    
    fileprivate func didFriendSelectPressed(_ friend: Friends) {
    
        if friend.friend_id != 0 {
            
            let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "friendProfileVc") as! FriendProfileViewController
            profileVc.profile_id = friend.friend_id
            
            self.navigationController?.pushViewController(profileVc, animated: true)
        }
    }
}

// MARK: - Invitees List View Controller

extension FriendsViewController {
    
    fileprivate func setupInviteesListController() {
     
        self.navigationItem.title = "Invitees"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FriendsViewController.didCancelButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FriendsViewController.doneButtonPressed(_:)))
        
        self.fullContactListfromDevice = CatchupContacts.sharedInstance.importContactsFromPhone()
        
        self.getInviteesFromServer()
        
    }
    
    fileprivate func getInviteesFromServer(){
            Utitlity.sharedInstance.showProgressHud()
            let param = ["user_id":String(Utitlity.sharedInstance.user_profile!.user_Id)]
            
            NetworkServices.sharedInstance.postWebServiceWith(paths.user_friends_list, params: param as [String:AnyObject], headers: [:], completion:
                {(success,responseDict) in
                    if success {
                        let dataArray = responseDict["data"]
                        if ((dataArray?.count)! > 0) {
                            HandleResponse.handleFriendListRespone(dataArray!)
                            self.updateContactsList()
                            HandleResponse.saveContactsInDB(phoneContacts: self.contactsArray)
                            self.getContacts(forIndex: self.friendsSegment.selectedSegmentIndex)
                        }
                    }
                    Utitlity.sharedInstance.hideProgressHud()
            })
        
    }
    
    fileprivate func inviteeSelectPressed(_ friend: Friends) {
        
        
    }
    
    func didCancelButtonPressed(_ sender: UIBarButtonItem) {
        if Utitlity.sharedInstance.contacts_Array.count > 0 {
            Utitlity.sharedInstance.contacts_Array.removeAllObjects()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonPressed(_ sender: UIBarButtonItem) {
        if Utitlity.sharedInstance.contacts_Array.count > 0 {
            if let delegate = self.delegate {
                delegate.selected(friends: Utitlity.sharedInstance.contacts_Array)
            }
            self.dismiss(animated: true, completion: nil)
        }
        else {
            
            Utitlity.sharedInstance.showAlert(self, message: "Please select atleast one contact from groups.")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

       // let friend = friends_list_Array[indexPath.row] as! Friends
        
        searchContacts(searchText: searchText)
    }
    
    func searchContacts(searchText:String) {
        
        friends_list_Array_temp.removeAllObjects();
        if(searchText.count > 0){
            for friend in friends_list_Array {
                var f:Friends = friend as! Friends
                if(f.friend_name.lowercased().contains(searchText.lowercased())){
                    friends_list_Array_temp.add(f)
                }
                
            }
        }
        else{
            friends_list_Array_temp = NSMutableArray(array: friends_list_Array)
        }
        
        tblFriends_List.reloadData()

    }
}
