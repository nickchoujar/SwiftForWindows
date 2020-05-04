//
//  EventDetailViewController.swift
//  CatchUp
//
//  Created by Bilal Hussain on 2/15/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class EventDetailViewController: UITableViewController {
    
    @IBOutlet weak var tbl_detial : UITableView!
    
    var selected_Event : Event!
    var selectedEventID: String = ""
    var numberOfrows = 0
    var attendingStatus = 0
    var dontShowAttendControls = 0
    var organiserId:Int64 = 0
    
    
    var eventsList_Array : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getEventsDetail()
        
        self.navigationItem.title = "Day Event"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(UIImage(named:"backIcon"), target: self, action: #selector(EventDetailViewController.popView))
    }
    
    func popView()  {
        
        if self.selectedEventID != "" {
            
            //            self.navigationController?.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEventsDetail() {
        
        var eventID: String = ""
        
        if self.selectedEventID != "" {
            
            eventID = self.selectedEventID
        }
        else {
            
            eventID = String(selected_Event.event_id)
        }
        
        let params = ["event_id":eventID]
        
        Utitlity.sharedInstance.showProgressHud()
        
        
        NetworkServices.sharedInstance.postWebServiceWith(paths.event_detail, params: params as [String : AnyObject] , headers: [:]) { (success, responseDict) in
            if success {
                
                if let dataDict = responseDict["data"] as? NSDictionary {
                    
                    if self.selectedEventID != "" {
                        
                        var date: String = ""
                        var organiserid: Int64 = 0
                        
                        
                        if let eventOrganiserId = dataDict["user_id"] as? Int64 {
                            self.organiserId = eventOrganiserId
                        }
                        
                        let event: Event = Event(responseDict: dataDict as! Dictionary<String, Any>)
                        
                        self.selected_Event = event
                        
                        for dictValue in self.selected_Event.invitees{
                            let dict = dictValue as! NSDictionary
                            var email:String = dict["email"] as! String
                            if(email == Utitlity.sharedInstance.user_profile!.user_email){
                                var attend:Int = dict["inv_status"] as! Int
                                self.attendingStatus = attend
                            }
                        }
                      
                        if(self.organiserId == Utitlity.sharedInstance.user_profile!.user_Id){
                            self.dontShowAttendControls = 1
                        }
                        
                    }
                    else {
                        
                        if let invitees = dataDict["friend_invitees"] as? Array<AnyObject> {
                            self.selected_Event.invitees = invitees as! NSArray
                        }
                        if let eventUserName = dataDict["user_fullname"] as? String {
                            self.selected_Event.event_user_Name = eventUserName
                        }
                        if let eventUserPicture = dataDict["user_picture"] as? String {
                            self.selected_Event.event_user_Pic = paths.Img_Base_Url+"users/"+eventUserPicture
                        }
                        
                        if let eventOrganiserId = dataDict["user_id"] as? Int64 {
                            self.organiserId = eventOrganiserId
                        }

                        if(self.organiserId == Utitlity.sharedInstance.user_profile!.user_Id){
                            self.dontShowAttendControls = 1
                        }

                    }
                    
                    
                    self.tbl_detial.reloadData()
                }
                
                Utitlity.sharedInstance.hideProgressHud()
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK :- Tableview Delegate and Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.selected_Event != nil {
        
            return 1
        }
        
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.selected_Event != nil {
        
            if self.dontShowAttendControls == 1 {
                
                return 4
            }
            else {
                
                return 6
            }
        }
        
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {//event cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventNamecell", for: indexPath) as! EventdetailTableViewCell
            
            
            if selected_Event.event_Picture != nil {
                
                if selected_Event.event_Picture != "" {
                    
                    
                    cell.event_imgVIew.af_setImage(withURL: URL.init(string: selected_Event.event_Picture)!, placeholderImage: UIImage(named:"placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                        
                        
                    })
                    
                    
                    cell.eventImageHConstraint.constant = 128
                }
                else {
                    
                    cell.eventImageHConstraint.constant = 0
                }
            }
            else {
                cell.eventImageHConstraint.constant = 0
            }
            
            cell.eventName.text = selected_Event.event_name
            return cell
            
            
        }else if indexPath.row == 1 {//event user cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            
            if selected_Event.event_user_Pic != nil {
                if selected_Event.event_user_Pic != "" {
                    
                    cell.profile_ImgView.af_setImage(withURL: URL.init(string: selected_Event.event_user_Pic)!, placeholderImage: UIImage(named:"placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                        
                        
                    })
                    cell.profileImageHConstraint.constant = 100
                }
                else {
                    
                    cell.profile_ImgView.image = UIImage(named: "placeholder")
                    cell.profileImageHConstraint.constant = 0
                }
            }
            else {
                
                cell.profile_ImgView.image = UIImage(named: "placeholder")
                cell.profileImageHConstraint.constant = 0
            }
            
            cell.lbl_title.text = selected_Event.event_user_Name
            
          //  if(selected_Event.event_user_Name == Utitlity.sharedInstance.user_profile!.user_name){
            
            
//            print(cell.lbl_title.text)
//            print(Utitlity.sharedInstance.user_profile!.user_name)
//            
//            if(cell.lbl_title.text == Utitlity.sharedInstance.user_profile!.user_name){
//                self.dontShowAttendControls = 1
//            }
            
            return cell
        }else if indexPath.row == 2 {//event detail cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventDetailCell", for: indexPath) as! EventdetailTableViewCell
            cell.eventTypeHConstraint.constant = 0
            cell.eventDate.text = selected_Event.event_date + " " + selected_Event.event_time
            cell.eventAddress.text = selected_Event.venue_address
            return cell
        }
        else if (self.dontShowAttendControls == 0){
            if indexPath.row == 3 {//event detail cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventAttendCell", for: indexPath) as! EventdetailTableViewCell
                
                if self.attendingStatus == 1{
                    cell.lblAttnedStatus.text = "Yes"
                    cell.lblAttnedStatus.textColor = UIColor.green
                }
                else if self.attendingStatus == 2{
                    cell.lblAttnedStatus.text = "No"
                    cell.lblAttnedStatus.textColor = UIColor.red
                }
                else if self.attendingStatus == 3{
                    cell.lblAttnedStatus.text = "Maybe"
                    cell.lblAttnedStatus.textColor = UIColor.orange
                }
                return cell
            }
            else if indexPath.row == 4 {//event detail cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventSetAttendCell", for: indexPath) as! EventdetailTableViewCell
                return cell
            }
        }
        
        //invitees cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventInviteesCell", for: indexPath) as! EventdetailTableViewCell
        cell.configureCell(selected_Event.invitees)
        
        return cell
    }
    
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            if selected_Event.event_Picture == nil {
                
                return 82
            }
            else {
                
                return 210
            }
        }else if indexPath.row == 1 {
            
            if selected_Event.event_user_Pic == nil {
                
                return 40
            }
            else {
                
                return 160
            }
        }
        
        if self.dontShowAttendControls == 0 {
        
            if indexPath.row == 3
            {
                return 35
            }
            else if indexPath.row == 4
            {
                return 40
            }
        }
        
        return 90
    }
    
    
    @IBAction func btnAttnedingYesPressed(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Attending", message: "Your status will be made available to the organiser and all the attendees ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{action in
            self.setAttendStatusYes()}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnAttnedingNoPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Not Attending", message: "Your status will be made available to the organiser and all the attendees ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{action in
            self.setAttendStatusNo()}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnAttnedingMaybePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Maybe", message: "Your status will be made available to the organiser and all the attendees ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{action in
            self.setAttendStatusMaybe()}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setAttendStatusYes()  {
        self.attendingStatus = 1
        self.tableView.reloadData()
        
        let params = ["user_id":String(Utitlity.sharedInstance.user_profile!.user_Id), "event_id":String(selected_Event.event_id), "inv_status":1, "email":Utitlity.sharedInstance.user_profile!.user_email] as [String : Any]
        Utitlity.sharedInstance.showProgressHud()
        NetworkServices.sharedInstance.postWebServiceWith(paths.send_invites, params: params as [String : AnyObject] , headers: [:]) { (success, responseDict) in
            if success {
                self.getEventsDetail()
            }
            else{
                Utitlity.sharedInstance.hideProgressHud()
            }
        }
        
    }
    
    func setAttendStatusNo()  {
        self.attendingStatus = 2
        self.tableView.reloadData()
        
        let params = ["user_id":String(Utitlity.sharedInstance.user_profile!.user_Id),"event_id":String(selected_Event.event_id), "inv_status":2, "email":Utitlity.sharedInstance.user_profile!.user_email] as [String : Any]
        
        Utitlity.sharedInstance.showProgressHud()
        NetworkServices.sharedInstance.postWebServiceWith(paths.send_invites, params: params as [String : AnyObject] , headers: [:]) { (success, responseDict) in
            if success {
                self.getEventsDetail()
            }
            else{
                Utitlity.sharedInstance.hideProgressHud()
            }
        }
        
    }
    
    func setAttendStatusMaybe()  {
        self.attendingStatus = 3
        self.tableView.reloadData()
        
        Utitlity.sharedInstance.showProgressHud()
        let params = ["user_id":String(Utitlity.sharedInstance.user_profile!.user_Id), "event_id":String(selected_Event.event_id), "inv_status":3, "email":Utitlity.sharedInstance.user_profile!.user_email] as [String : Any]
        
        NetworkServices.sharedInstance.postWebServiceWith(paths.send_invites, params: params as [String : AnyObject] , headers: [:]) { (success, responseDict) in
            if success {
                self.getEventsDetail()
            }
            else{
                Utitlity.sharedInstance.hideProgressHud()
            }
        }
        
    }
    
    // Not being used at the moment
    
    func checkAndUpdateinviteeList(status:Int){
        
        for dict in selected_Event.invitees
        {
            var d = dict as! [String:String]
            var email:String = d["email"] as! String
            
            if email == Utitlity.sharedInstance.user_profile!.user_email {
                
            }
        }
        
    }
    
}
