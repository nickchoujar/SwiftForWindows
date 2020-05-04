//
//  InviteesGroupViewController.swift
//  CatchUp
//
//  Created by Bilal Hussain on 2/4/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class InviteesGroupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var invitees_Group_Array : NSMutableArray = []
    var groupd_Id : String!
    
    @IBOutlet weak var tbl_invitees_Group : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getInviteesFromServer()
        self.navigationItem.title = "Invitees"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(UIImage(named:"backIcon"), target: self, action: #selector(EventDetailViewController.popView))
    }
    func popView()  {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    func getInviteesFromServer(){
        Utitlity.sharedInstance.showProgressHud()
        let param = ["user_id":String(Utitlity.sharedInstance.user_profile!.user_Id),"group_id":groupd_Id]
        NetworkServices.sharedInstance.postWebServiceWith(paths.user_friend_invitee, params: param as [String:AnyObject], headers: [:], completion:
            {(success,responseDict) in
                if success {
                    let dataArray = responseDict["data"]
                    if ((dataArray?.count)! > 0) {
                        for friendDict in dataArray as! [AnyObject]{
                            var picture : String = ""
                            
                            if let pic = friendDict["thum_picture"] as? String{
                                picture = pic
                            }
                            else {
                            
                                picture = ""
                            }
                            let friend = Friends(fid: friendDict["friend_id"] as! Int64, fName: friendDict["name"] as! String, fImage: picture, fgname: friendDict["group_name"] as! String, fgId:0, isCatchupUser: false)
                            self.invitees_Group_Array.add(friend)
                        }
                        self.tbl_invitees_Group.reloadData()
                    }
                }
                Utitlity.sharedInstance.hideProgressHud()
        })
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
        return invitees_Group_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteeCell", for: indexPath) as! InviteesTableViewCell
        let invitee = invitees_Group_Array[indexPath.row] as! Friends
        cell.configureCell(invitee, isGroupList: false)
        cell.inviteeDelegate = self
        return cell
    }
    
}
extension InviteesGroupViewController : inviteesCellDelegate {
    func inviteFriend(_ cell: InviteesTableViewCell, friend_id: String, group_id: String) {
        let pred = NSPredicate(format: "friend_id == %@", argumentArray: [friend_id])
        let filterArr = Utitlity.sharedInstance.invitees_Array.filtered(using: pred)
        let dict = ["friend_id":friend_id]
        if filterArr.count>0 {
            Utitlity.sharedInstance.invitees_Array.remove(dict)
        }else{
            Utitlity.sharedInstance.invitees_Array.add(dict)
        }
        tbl_invitees_Group.reloadData()
    }
    func friendGrouplist(_ cell: InviteesTableViewCell, friend_group_Id: String) {
        
    }
}
