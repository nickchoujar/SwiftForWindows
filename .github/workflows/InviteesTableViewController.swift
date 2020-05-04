//
//  InviteesTableViewController.swift
//  CatchUp
//
//  Created by Macbook on 1/19/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class InviteesTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var invitees_Array : NSMutableArray = []
    
    var selectedInviteesArray : NSMutableArray = []
    
    var selectedFriend: Friends!
    
    @IBOutlet weak var inviteesSegment: UISegmentedControl!
    
    @IBOutlet weak var tbl_invitees : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getInviteesFromServer()
        self.navigationItem.title = "Invi"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(InviteesTableViewController.didCancelButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(InviteesTableViewController.didDoneButtonPressed(_:)))
        
        
        self.getContacts(forIndex: self.inviteesSegment.selectedSegmentIndex)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "InviteesDetail" {
            
            let inviteesGroupViewController: InviteesGroupViewController = segue.destination as! InviteesGroupViewController
            
            inviteesGroupViewController.groupd_Id = String(self.selectedFriend.friend_gp_id)
        }
    }
    
    func popView()  {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func getContacts(forIndex selectedSegmentIndex: Int) {
        
        let friendType: FriendType = FriendType(rawValue: selectedSegmentIndex)!
        
        switch friendType {
        case .Email:
            
            self.invitees_Array = Friends.getFriendsList()
            
            break
            
        case .Mobile:
            
            self.invitees_Array = Friends.getPhoneContactsList()
            
            break
        }
        
        
        self.tbl_invitees.reloadData()
    }
    
    @IBAction func didChangeSegmentValue(_ sender: UISegmentedControl) {
        
        self.getContacts(forIndex: sender.selectedSegmentIndex)
    }
    
    func getInviteesFromServer(){
        
        let friendsList = Friends.getAllFriendsList()
        
        if friendsList.count > 0 {
            
            self.invitees_Array = friendsList
            self.tbl_invitees.reloadData()
        }
        else {
        
            Utitlity.sharedInstance.showProgressHud()
            let param = ["user_id":String(Utitlity.sharedInstance.user_profile!.user_Id)]
            
            
            
            NetworkServices.sharedInstance.postWebServiceWith(paths.user_friends_list, params: param as [String:AnyObject], headers: [:], completion:
                {(success,responseDict) in
                    if success {
                        let dataArray = responseDict["data"]
                        if ((dataArray?.count)! > 0) {
                            
                            HandleResponse.handleFriendListRespone(dataArray!)
                            
                            self.getContacts(forIndex: self.inviteesSegment.selectedSegmentIndex)
                            
                            self.tbl_invitees.reloadData()
                        }
                    }
                    Utitlity.sharedInstance.hideProgressHud()
            })
        }
    }
    
    
    func didCancelButtonPressed(_ sender: UIBarButtonItem) {
    
        if self.selectedInviteesArray.count > 0 {
            
            Utitlity.sharedInstance.invitees_Array.removeAllObjects()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func didDoneButtonPressed(_ sender: UIBarButtonItem) {
        
        if Utitlity.sharedInstance.invitees_Array.count > 0 {
        
//            if let delegate = self.delegate {
//                
//                delegate.selected(friends: Utitlity.sharedInstance.invitees_Array)
//            }
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
        
            Utitlity.sharedInstance.showAlert(self, message: "Please select atleast one contact from groups.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return invitees_Array.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteeCell", for: indexPath) as! InviteesTableViewCell
        let invitee = invitees_Array[indexPath.row] as! Friends
        cell.configureCell(invitee, isGroupList: false)
        cell.inviteeDelegate = self
        
//        if self.selectedInviteesArray.count > 0 {
//        
//            for selectedValue in self.selectedInviteesArray {
//                
//                let selectedFriend = selectedValue as! Friends
//                
//                if invitee.friend_id == selectedFriend.friend_id {
//                    
//                    cell.accessoryType = .checkmark
//                }
//                else {
//                    
//                    cell.accessoryType = .none
//                }
//            }
//        }
//        else {
//        
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let friend: Friends = self.invitees_Array[indexPath.row] as! Friends

        self.selectedFriend = friend;
//        
//        self.performSegue(withIdentifier: "InviteesDetail", sender: nil)
    }

}

extension InviteesTableViewController : inviteesCellDelegate {
    
    func inviteFriend(_ cell: InviteesTableViewCell, friend_id: String, group_id: String) {
        
        let pred = NSPredicate(format: "friend_id == %@", argumentArray: [friend_id])
        let filterArr = Utitlity.sharedInstance.invitees_Array.filtered(using: pred)
        let dict = ["friend_id":friend_id]
        if filterArr.count>0 {
            Utitlity.sharedInstance.invitees_Array.remove(dict)
        }else{
            Utitlity.sharedInstance.invitees_Array.add(dict)
        }
        tbl_invitees.reloadData()
    }
    func friendGrouplist(_ cell: InviteesTableViewCell, friend_group_Id: String) {

        
    }
}

