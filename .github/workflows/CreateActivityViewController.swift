//
//  CreateActivityViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/28/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import MessageUI
import DatePickerDialog
import MMPickerView

class CreateActivityViewController: UIViewController, MapLocationViewControllerDelegate, InviteesFriendsViewDelegate {
    
    @IBOutlet weak var txt_event_name: UITextField!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet var btn_EventType: UIButton!
    @IBOutlet weak var btn_Category: UIButton!
    @IBOutlet weak var btn_start_date: UIButton!
    @IBOutlet weak var btn_end_date: UIButton!
    @IBOutlet weak var btn_time: UIButton!
    @IBOutlet weak var btn_search_location: UIButton!
    @IBOutlet weak var btnType_Event: UIButton!
    @IBOutlet weak var btn_Invitee: UIButton!
    @IBOutlet weak var btnSchedule_Event: UIButton!
    @IBOutlet weak var btn_public: UIButton!
    @IBOutlet weak var btn_Private: UIButton!
    @IBOutlet weak var event_imgView: UIImageView!
    @IBOutlet weak var btn_hideImage: UIButton!
    @IBOutlet weak var btn_End_time: UIButton!
    
    
    var selected_cat_id : String!
    var selected_eventType_id : String!
    var event_privacy : String = "Public"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Side bar menu setting
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)), for: .touchUpInside)

            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        else {
        
            menuButton.addTarget(self, action: #selector(self.dismissVC(_:)), for: .touchUpInside)
        }
        
        event_imgView.layer.cornerRadius = event_imgView.frame.size.width/2
        event_imgView.clipsToBounds = true
        
        selected_cat_id = ""
        
        clearAllFieldsAfterSuccess()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SelectLocationSegue" {
        
            let mapLocationViewController: MapLocationViewController = segue.destination as! MapLocationViewController
            
            mapLocationViewController.delegate = self
        }
        else if segue.identifier == "SearchInviteesSegue" {
        
            let navigationView: UINavigationController = segue.destination as! UINavigationController
            
            let inviteesTableViewController: FriendsViewController = navigationView.childViewControllers[0] as! FriendsViewController
            inviteesTableViewController.controllerType = FriendControllerType.InviteesList
            
            inviteesTableViewController.delegate = self
        }
        else if segue.identifier == "ScheduleSegue" {
        
            let navigationView: UINavigationController = segue.destination as! UINavigationController
            
            let scheduleViewController: ScheduleViewController = navigationView.childViewControllers[0] as! ScheduleViewController
            
//            scheduleViewController.delegate = self
        }
        else if segue.identifier == "DatePickerSegue" {
        
            let datePickerViewController: DatePickerViewController = segue.destination as! DatePickerViewController
            datePickerViewController.providesPresentationContextTransitionStyle = true
            datePickerViewController.definesPresentationContext = true
            datePickerViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            
            datePickerViewController.delegate = self
        }
    }
    
    
    
    // MARK: - InviteesFriendsViewDelegate
    
    func selected(friend: Friends) {
        
        
        
    }
    
    func selected(friends: NSArray) {
        
        if Utitlity.sharedInstance.contacts_Array.count > 0 {
        
//            let attrString: NSAttributedString = NSAttributedString(string: self.getInvitees_Id())
            
            let attrString: NSAttributedString = NSAttributedString(string: String(Utitlity.sharedInstance.contacts_Array.count))
            
            self.btn_Invitee.setAttributedTitle(attrString, for: .normal)
        }
        else {
        
            let attrs = [NSUnderlineStyleAttributeName:NSUnderlineStyle.patternSolid]
            let attrString: NSAttributedString = NSAttributedString(string: "Search Invitees", attributes: attrs)
            
            self.btn_Invitee.setAttributedTitle(attrString, for: .normal)
        }
        
    }
    
    // MARK: - MapLocationViewControllerDelegate
    
    func selected(location: NearestLocation) {
        
        let attrString: NSAttributedString = NSAttributedString(string: location.loc_address)
        self.btn_search_location.setAttributedTitle(attrString, for: .normal)
        Utitlity.sharedInstance.selected_location = location
    }

    //MARK:- Buttons Actions
    func dismissVC(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btn_selectStartDate_Action(_ sender: Any) {
        
        txt_event_name.resignFirstResponder()

    }
    
    @IBAction func btn_selectEndDate_Action(_ sender: Any) {
        
        txt_event_name.resignFirstResponder()
        
        DatePickerDialog().show(title: "Date ", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if date != nil {
                self.btn_end_date.setTitle("\(date!.toString())", for: .normal)
            }
        }
    }
    
    @IBAction func btn_time_Action(_ sender: Any) {
        
        txt_event_name.resignFirstResponder()
        
        DatePickerDialog().show(title: "Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if date != nil {
                self.btn_time.setTitle("\(date!.toTimeString())", for: .normal)
            }
        }
    }
    
    @IBAction func btn_End_Time_Action(_ sender: Any) {
        
        txt_event_name.resignFirstResponder()
        
        DatePickerDialog().show(title: "End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if date != nil {
                self.btn_End_time.setTitle("\(date!.toTimeString())", for: .normal)
            }
        }
    }
    
    @IBAction func btn_Category_Action(_ sender: Any) {
        
        txt_event_name.resignFirstResponder()
        
        var catsArray: [String] = []
        
        let user: User = Utitlity.sharedInstance.user_profile!;
        
        for catObject: CategoryObject in user.cat_data {
            
            catsArray.append(catObject.cat_name)
        }
        
        MMPickerView.showPickerView(in: self.view, withStrings: catsArray, withOptions: ["selectedObject":"Sports"], withWidth:self.view.frame.size.width, completion:
            {(selectedValue) in
                self.btn_Category.setTitle(selectedValue, for: .normal)
                
                for catObject: CategoryObject in (Utitlity.sharedInstance.user_profile?.cat_data)! {
                    
//                    filterArr.append(catObject.cat_id)
                    
                    if selectedValue == catObject.cat_name {
                        
                        self.selected_cat_id = String(catObject.cat_id)
                    }
                }
        })
    }
    
    @IBAction func btn_TypeofEvent_Action(_ sender: Any) {
        
        txt_event_name.resignFirstResponder()
        
        var event_type_Array: [String] = []
        
        for eventObject: EventTypeObject in (Utitlity.sharedInstance.user_profile?.event_type_data)! {
            
            event_type_Array.append(eventObject.event_type)
        }
        

        MMPickerView.showPickerView(in: self.view, withStrings: event_type_Array, withOptions: ["MMValueY":"5"], withWidth:self.view.frame.size.width, completion:
            {(selectedValue) in
                self.btnType_Event.setTitle(selectedValue, for: .normal)
                
                for eventObject: EventTypeObject in (Utitlity.sharedInstance.user_profile?.event_type_data)! {
                    
                    if selectedValue == eventObject.event_type {
                    
                        self.selected_eventType_id = String(eventObject.event_type_id)
                    }
                }
        })
    }
    @IBAction func btn_Public_Action(_ sender: Any) {
        event_privacy = "Public"
        btn_public.setImage(#imageLiteral(resourceName: "sent_request"), for: .normal)
        btn_Private.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
    }
    @IBAction func btn_Private_Action(_ sender: Any) {
        event_privacy = "Private"
        btn_public.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        btn_Private.setImage(#imageLiteral(resourceName: "sent_request"), for: .normal)

    }
    @IBAction func btn_UploadPic_Action(_ sender: Any) {
        self.showImageTakingOptions()
    }
    @IBAction func btn_HideImage_Action(_ sender: Any) {
        self.event_imgView.image = nil
        btn_hideImage.isHidden = true
    }
    @IBAction func btn_Save_Action(_ sender: Any) {
        
        txt_event_name.resignFirstResponder()

        print((txt_event_name.text?.characters.count)!)
        print(selected_cat_id.characters.count)
        print(selected_eventType_id.characters.count)
        print(btn_end_date.titleLabel?.text!)
        print(btn_start_date.titleLabel?.text!)
        print(btn_time.titleLabel?.text!)
        print(Utitlity.sharedInstance.contacts_Array.count)
//        print(Utitlity.sharedInstance.selected_location!)
        print(event_privacy.characters.count)
        
        if (txt_event_name.text?.characters.count)! > 0 && /*selected_cat_id.characters.count > 0 && selected_eventType_id.characters.count > 0 &&  btn_end_date.titleLabel?.text != "Select End Date" && */btn_start_date.titleLabel?.text != "Select Start Date" && btn_time.titleLabel?.text != "Select Time" && Utitlity.sharedInstance.contacts_Array.count>0 && Utitlity.sharedInstance.selected_location != nil && event_privacy.characters.count>0 {
            
            Utitlity.sharedInstance.showProgressHud()
            var date = ""
            if let selectedDate = btn_start_date.titleLabel?.text! {
                date = selectedDate
            }
            else {
                date = ""
            }
            
            var time = ""
            
            if let selectedTime = btn_time.titleLabel?.text! {
                time = selectedTime
            }
            else {
                time = ""
            }
            
            var endDate = ""
            
            if let selectedDate = btn_end_date.titleLabel?.text! {
                
                endDate = selectedDate
            }
            else {
                
                endDate = ""
            }
            
            var endTime = ""
            
            if let selectedTime = btn_End_time.titleLabel?.text! {
                
                endTime = selectedTime
            }
            else {
                
                endTime = ""
            }
            
            //var con = NSMutableArray = []
            var contacts_Array : NSMutableArray = []
            var sendingArray : NSMutableArray = []
            
            contacts_Array = Utitlity.sharedInstance.contacts_Array
            for contactDict in Utitlity.sharedInstance.contacts_Array {
                let dict: [String: String] = contactDict as! [String : String]
                if (dict["friend_id"] != nil) {
                  sendingArray.add(contactDict)
                }
            }
            
            var params = [
                "user_id":String(Utitlity.sharedInstance.user_profile!.user_Id),
                "event_name":txt_event_name.text!,
                "cat_id":"1",
                "date":date,
                "time":time,
                "event_type":"1",
                "event_privacy":event_privacy,
                "friend_ids" : sendingArray,
                "activity_secdule":self.getActivityArray(),
                "venue_location":Utitlity.sharedInstance.selected_location!.loc_Name,
                "venue_link":"",
                "venue_address":Utitlity.sharedInstance.selected_location!.loc_address,
                "venue_late":Utitlity.sharedInstance.selected_location!.loc_lat,
                "venue_long":Utitlity.sharedInstance.selected_location!.loc_long,
                "end_date":date,
                "end_time":endTime
                ] as [String : AnyObject]
            
            print(params)

            NetworkServices.sharedInstance.uploadImageWithparams(paths.add_new_event, img: event_imgView.image!, params: params, completion: { (success , responseDict) in
                if success {
                    if let dataDict = responseDict["data"] as? NSDictionary {
                        let event_id: String = dataDict["event_id"] as! String
                        self.sendSMSToInviteeUsers(forEvent: String(event_id))
                    }
                }
                Utitlity.sharedInstance.hideProgressHud()
            })
        }
        else {
            Utitlity.sharedInstance.showAlert(self, message: "All fields are required")
        }
    }
    
    func sendSMSToInviteeUsers(forEvent eventId: String) {

       let allContacts: NSMutableArray = Friends.getMobileOnlyContacts(contacts:CatchupContacts.sharedInstance.importContactsFromPhone())
       // let allContacts: NSMutableArray = Friends.getPhoneContactsList()
        var smsContacts: NSMutableArray = NSMutableArray()
        
        for contactDict in Utitlity.sharedInstance.contacts_Array {
            
            let dict: [String: String] = contactDict as! [String : String]
            if (dict["friend_phoneNumber"] != nil){
            let friendId: String = dict["friend_phoneNumber"]!
            
            for allContactDict in allContacts {
                
                let contact: Friends = allContactDict as! Friends
                let contactId: String = String(contact.friend_phoneNumber)
                
                if friendId == contactId {
                    
                    if !contact.friend_isCatchupUser {
                        smsContacts.add(contact)
                    }
                }
            }
            }
        }
        
        if smsContacts.count > 0 {
        
            Utitlity.sharedInstance.showAlert(self, message: "Some invitess were invited using their mobile numbers. \n Send them an invite through SMS ?", completion: { (alertAction) in
                
                Utitlity.sharedInstance.contacts_Array = []
                Utitlity.sharedInstance.contacts_Array = smsContacts
                
                DynamicLinkUtility.inviteFriendsViaSMS(withEventId: eventId, onTarget: self)
                
                self.updateEventUI()
                
            })
            
//            , cancelAction: { (cancelAction) in
//
//                self.updateEventUI()
//
//                self.dismiss(animated: true, completion:    nil)
//            })
        }
        else {
          
            Utitlity.sharedInstance.showAlert(self, message: "Event successfully created", completion: { (alertAction) in
                
                self.updateEventUI()
            
                self.dismiss(animated: true, completion:    nil)
            })
        }
        
    }
    
    private func updateEventUI() {
    
//      Utitlity.sharedInstance.contacts_Array = []
        Utitlity.sharedInstance.schedules_Array = []
        Utitlity.sharedInstance.selected_location = nil
        self.clearAllFieldsAfterSuccess()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationHistoryEventFromServer"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationMapEventFromServer"), object: nil)
        
    }
    
    func getActivityArray() -> NSMutableArray{
        let schadules_arr : NSMutableArray = []
        for schadule in Utitlity.sharedInstance.schedules_Array as NSArray as! [Schedule]  {
            let dict =  ["time":schadule.sch_Time,"activity":schadule.sch_Activity]
            schadules_arr.add(dict)
        }
        return schadules_arr
    }
    
    func getInvitees_Id() -> String {
        var strId = ""
        
        let valuesArray: NSMutableArray = NSMutableArray()
        
        for dictValue in Utitlity.sharedInstance.contacts_Array {
            
            let dict = dictValue as! [String: String]
            
            valuesArray.add(dict["friend_id"]!)
        }
        
        strId = valuesArray.componentsJoined(by: ",")
        return strId
    }
    
    
    func clearAllFieldsAfterSuccess() {
        
        txt_event_name.text = ""
        selected_cat_id = ""
        selected_eventType_id = ""
        
        btnType_Event.setTitle("Types of Event", for: .normal)
        btn_Category.setTitle("Select Category", for: .normal)
        btn_start_date.setTitle("Select Start Date", for: .normal)
        btn_end_date.setTitle("Select End Date", for: .normal)
        btn_time.setTitle("Start Time", for: .normal)
        btn_End_time.setTitle("End Time", for: .normal)
        
        let attrs: [String: Any] = [NSUnderlineStyleAttributeName:NSUnderlineStyle.patternSolid.rawValue]
        
        
        let attrLocString: NSAttributedString = NSAttributedString(string: "Search", attributes: attrs)
 
        btn_search_location.setAttributedTitle(attrLocString, for: .normal)
        
        let attrInviString: NSAttributedString = NSAttributedString(string: "Search Invitees", attributes: attrs)
        
        self.btn_Invitee.setAttributedTitle(attrInviString, for: .normal)
        
        let attrEventString: NSAttributedString = NSAttributedString(string: "Schedule of Event", attributes: attrs)
        
     //   self.btnSchedule_Event.setAttributedTitle(attrEventString, for: .normal)
        
        self.btn_public.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        self.btn_Private.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        
    }
}

extension CreateActivityViewController: DatePickerViewDelegate {

    func datePickerView(_ datePickerView: DatePickerViewController, selectedDate date: Date?, stringDate: String?) {
     
        if stringDate != "" {
         
            self.btn_start_date.setTitle(stringDate, for: .normal)
        }
    }
}

/*
 ("user_id", 
 "event_name", 
 "cat_id", 
 "date",
 "time", 
 "end_date", 
 "end_time", 
 "event_type_id", 
 "event_privacy", 
 "venue_location", 
 "venue_link", 
 "venue_address", 
 "venue_late", 
 "venue_long", 
 "date_created", 
 "created_by")
 
 
 */

extension CreateActivityViewController : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        Utitlity.sharedInstance.contacts_Array = []
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
        self.dismiss(animated: true, completion:    nil)
    }
}

extension CreateActivityViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.text = ""
        
        return true
    }
}

extension CreateActivityViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func showImageTakingOptions(){
        let alert  = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let libraryAction = UIAlertAction(title: "Image From Library", style: .default, handler:{ action in
            self.takeImageFromLibrary()
        })
        let cameraAction = UIAlertAction(title: "Take Image From Camera", style: .default, handler:{ action in
            self.captureImageFromCamera()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        self.present(alert, animated: true, completion: nil)
    }
    
    func captureImageFromCamera(){
        if(  UIImagePickerController.isSourceTypeAvailable(.camera))
            
        {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        else
        {
            let actionController: UIAlertController = UIAlertController(title: "Camera is not available",message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void     in
                //Just dismiss the action sheet
            }
            
            actionController.addAction(cancelAction)
            self.present(actionController, animated: true, completion: nil)
            
        }
    }
    
    func takeImageFromLibrary(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        event_imgView.image = image
        event_imgView.isHidden = false
        btn_hideImage.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
