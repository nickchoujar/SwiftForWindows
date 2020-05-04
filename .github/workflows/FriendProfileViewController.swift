//
//  FriendProfileViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/27/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class FriendProfileViewController: UITableViewController {
    
    
    @IBOutlet var tbl_profile: UITableView!
    
    
    var profileImage: UIImage!
    var profile_id : Int64!
    var isFromUserProfile: Bool = false
    var friend_Detail : Friend_Detail!
    var isProfile_Editable : Bool = false
    var updatedProfileCell : ProfileTableViewCell!
    
    var user_profile_Options_Array : NSMutableArray  = ["", "Full Name", "Email", "Mobile No."]
    var user_profile_Options_Icons_Array = ["","nameIcon","email_icon","mobileNo_icon"]
    var friend_profile_Options_Array : NSMutableArray = ["", "Friend Name", "Address", "Date of Birth", "Facebook ID", "Skype ID", "Email", "Mobile No."]
    var friend_profile_Options_Icons_Array = ["","nameIcon","address-Icon","DOB-Icon","fb_icon","skype-icon","email_icon","mobileNo_icon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if isFromUserProfile == true {//user profile setting
            
            self.setUserProfileObject()
            self.getUserProfile()
        }
        else{//friends profile setting
            self.getProfile()
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(UIImage(named:"backIcon"), target: self, action: #selector(EventDetailViewController.popView))
    }
    
    func setUserProfileObject() {
    
        friend_Detail = Friend_Detail(fid: Int64(Utitlity.sharedInstance.user_profile!.user_Id), fName: Utitlity.sharedInstance.user_profile!.user_name, fImage: (Utitlity.sharedInstance.user_profile?.user_Img_Url)!, fgname: "", faddress: "", fDob: "", fFb_Id: "", fskype_Id: "", fEmail: Utitlity.sharedInstance.user_profile!.user_email, fMobileNo: Utitlity.sharedInstance.user_profile!.user_phone, fthumbImgUrl:"")
        self.navigationItem.title = friend_Detail.friend_name
    }
    
    func popView()  {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK:- Api methods
    func getUserProfile() {
        Utitlity.sharedInstance.showProgressHud()
        let param = ["user_id":String(profile_id)]
        NetworkServices.sharedInstance.postWebServiceWith(paths.user_profile, params: param as [String:AnyObject], headers: [:], completion: {(success,responseDict) in
            if success {
                let data_Dict = responseDict["data"] as? [String:AnyObject]
                if (data_Dict != nil) {
                    
                    var picture : String = ""
                    var email : String = ""
                    var name : String = ""
                    var userId : String = ""
                    var phone : String = ""
                    
                    
                    if let pic = data_Dict!["picture"] as? String{
                        picture = pic
                    }
                    
                    if let user_email = data_Dict!["user_email"] as? String {
                        email = user_email
                    }
                    if let user_fullname = data_Dict!["user_fullname"] as? String{
                        name = user_fullname
                    }
                    if let user_id = data_Dict!["user_id"] as? String{
                        userId = user_id
                    }
                    if let user_phone = data_Dict!["user_phone"] as? String{
                        phone = user_phone
                    }
                    
                    self.friend_Detail.friend_Email = email
                    self.friend_Detail.friend_image = paths.Img_Base_Url+"users/"+picture
                    self.friend_Detail.friend_name = name
                    self.friend_Detail.friend_Mobile_no = phone
                    
                    
                    Utitlity.sharedInstance.user_profile?.user_fullname = self.friend_Detail.friend_name
                    Utitlity.sharedInstance.user_profile?.user_email = self.friend_Detail.friend_Email
                    Utitlity.sharedInstance.user_profile?.user_Img_Url = self.friend_Detail.friend_image
                    Utitlity.sharedInstance.user_profile?.user_phone = self.friend_Detail.friend_Mobile_no
                    
                    self.navigationItem.title = self.friend_Detail.friend_name
                    self.tbl_profile.reloadData()
                }
            } else {
                Utitlity.sharedInstance.showAlert(self, message: "Request data not found")
            }
            Utitlity.sharedInstance.hideProgressHud()
            
        })
    }
    
    func getProfile() {
        Utitlity.sharedInstance.showProgressHud()
        let param = ["friend_id":String(profile_id)]
        NetworkServices.sharedInstance.postWebServiceWith(paths.user_friend_profile, params: param as [String:AnyObject], headers: [:], completion: {(success,responseDict) in
            if success {
                let data_Dict = responseDict["data"] as? [String:AnyObject]
                if (data_Dict != nil) {
                    
                    var picture : String = ""
                    var address : String = ""
                    var dob : String = ""
                    var facebook_link : String = ""
                    var email : String = ""
                    var name : String = ""
                    var skype_id : String = ""
                    var thumb_picture : String = ""
                    var phone : String = ""
                    
                    
                    if let pic = data_Dict!["picture"] as? String{
                        picture = pic
                    }
                    if let addres = data_Dict!["address"] as? String{
                        address = addres
                    }
                    if let db = data_Dict!["dob"] as? String{
                        dob = db
                    }

                    if let fblink = data_Dict!["facebook_link"] as? String{
                        facebook_link = fblink
                    }
                    if let emal = data_Dict!["email"] as? String{
                        email = emal
                    }
                    if let nam = data_Dict!["name"] as? String{
                        name = nam
                    }
                    if let skypeId = data_Dict!["skype_id"] as? String{
                        skype_id = skypeId
                    }
                    if let thumpic = data_Dict!["thum_picture"] as? String{
                        thumb_picture = thumpic
                    }
                    if let phn = data_Dict!["phone"] as? String{
                        phone = phn
                    }
                    
                    self.friend_Detail = Friend_Detail(fid: data_Dict!["friend_id"] as! Int64, fName: name, fImage: picture, fgname: "", faddress: address, fDob: dob, fFb_Id: facebook_link, fskype_Id: skype_id, fEmail: email, fMobileNo: phone, fthumbImgUrl:thumb_picture)
                    Utitlity.sharedInstance.updated_friend_detail = self.friend_Detail
                    self.navigationItem.title = self.friend_Detail.friend_name
                    self.tbl_profile.reloadData()
                }
            } else {
                Utitlity.sharedInstance.showAlert(self, message: "Request data not found")
            }
            Utitlity.sharedInstance.hideProgressHud()
            
        })
    }
    
    //MARk:- TableView Delegate and datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromUserProfile == true {
            return user_profile_Options_Array.count
        }
        return friend_profile_Options_Array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ProfileTableViewCell!
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileImgCell") as! ProfileTableViewCell
            self.updatedProfileCell = cell
            if isFromUserProfile == false {
                cell.btn_Delete_User.isHidden = false
            }
        }else if (((indexPath.row == user_profile_Options_Array.count-1 && isFromUserProfile == true) || (indexPath.row == friend_profile_Options_Array.count-1 && isFromUserProfile == false)) && isProfile_Editable == true) {
            cell = tableView.dequeueReusableCell(withIdentifier: "saveProfileCell") as! ProfileTableViewCell!
            cell.profileDelegate = self
            return cell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "profileDetailCell") as! ProfileTableViewCell!
            if isFromUserProfile == true {//user profile setting
                cell.lbl_title.text = user_profile_Options_Array[indexPath.row] as? String
                cell.icon_imgView.image = UIImage(named: user_profile_Options_Icons_Array[indexPath.row])
            }else{//friend profile setting
                cell.lbl_title.text = friend_profile_Options_Array[indexPath.row] as? String
                cell.icon_imgView.image = UIImage(named: friend_profile_Options_Icons_Array[indexPath.row])
            }
        }
        
        cell.indexPath = indexPath.row
        cell.profileDelegate = self
        if friend_Detail != nil {//friend detail update
            cell.configureCell(friend_Detail, isCellEditable: isProfile_Editable)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200.0
        }else if indexPath.row  == 1 && isFromUserProfile == true {
            return 100
        }else if (((indexPath.row == user_profile_Options_Array.count-1 && isFromUserProfile == true) || (indexPath.row == friend_profile_Options_Array.count-1 && isFromUserProfile == false)) && isProfile_Editable == true) {
            return 130
        }
        return 80.0
    }
    
}
extension FriendProfileViewController:profileCellDelegate{
    
    func updateProflePicture(_ cell: ProfileTableViewCell) {
        updatedProfileCell = cell
        self.showImageTakingOptions()
    }
    
    func updateProfile(_ cell: ProfileTableViewCell) {
        if !isProfile_Editable {
            
            let str = ""
            if(isFromUserProfile == true){
                self.user_profile_Options_Array.add(str)
            }else{
                self.friend_profile_Options_Array.add(str)
            }
            isProfile_Editable = true
            tbl_profile.reloadData()
        }
        else {
        
            
        }
    }
    
    func deleteFriend(_ cell: ProfileTableViewCell) {
        Utitlity.sharedInstance.showProgressHud()
        let param = ["friend_id":String(profile_id)]
        NetworkServices.sharedInstance.postWebServiceWith(paths.delete_friend, params: param as [String:AnyObject], headers: [:], completion:
            {(success,responseDict) in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    Utitlity.sharedInstance.showAlert(self, message: "Request do not complete due to some sever error.")
                }
                Utitlity.sharedInstance.hideProgressHud()
        })
    }
    
    func saveUpdatedProfile(_ cell: ProfileTableViewCell) {
        
        if isFromUserProfile == true {//user profile update.
//            
//            let user_fullname = Utitlity.sharedInstance.updated_user_profile_Detail!.user_name
//            let user_phone = Utitlity.sharedInstance.updated_user_profile_Detail!.user_phone
//            let user_email = Utitlity.sharedInstance.updated_user_profile_Detail!.user_email
//            
//            if user_fullname != cell. {
//                <#code#>
//            }
            
            self.updateUserProfile()
        }
        else {// update friend profile.
            self.updateFriendProfile()
        }
        tbl_profile.reloadData()
    }
    
    func resetProfileView() {
    
        isProfile_Editable = false
        
        if isFromUserProfile == true {//user profile update.
            
            self.user_profile_Options_Array.removeLastObject()
        }
        else {// update friend profile.
            
            self.friend_profile_Options_Array.removeLastObject()
        }
        
        tbl_profile.reloadData()
    }
    
    func updateUserProfile(){
        Utitlity.sharedInstance.showProgressHud()
        let param = [
            "user_id":String(profile_id),
            "user_fullname":Utitlity.sharedInstance.updated_user_profile_Detail!.user_name,
            "user_phone":Utitlity.sharedInstance.updated_user_profile_Detail!.user_phone,
            //"user_phone":"03424",
            "user_email":Utitlity.sharedInstance.updated_user_profile_Detail!.user_email
        ]
        
//        NetworkServices.sharedInstance.uploadImageWithparams(paths.user_friend, img: friend_imgView.image!, params: param as [String : AnyObject], completion: { (success, responseDict) in
//            if success {
//                Utitlity.sharedInstance.showAlert(self, message: "Your profile has been updated successfully.")
//                Utitlity.sharedInstance.user_profile = Utitlity.sharedInstance.updated_user_profile_Detail
//                constants.archiveUser(Utitlity.sharedInstance.updated_user_profile_Detail)
//                
//                self.resetProfileView()
//                
//                _ = self.navigationController?.popViewController(animated: true)
//            }else{
//                Utitlity.sharedInstance.showAlert(self, message: "Request do not complete due to some sever error.")
//            }
//            Utitlity.sharedInstance.hideProgressHud()
//        })
        
        
        NetworkServices.sharedInstance.uploadImageWithparams(paths.user_profile_update, img: self.updatedProfileCell.profile_ImgView.image!, params: param as [String : AnyObject], completion: { (success , responseDict) in
            
            print(responseDict)
            
            if success {
                
                Utitlity.sharedInstance.showAlert(self, message: "Your profile has been updated successfully.")
                Utitlity.sharedInstance.user_profile = Utitlity.sharedInstance.updated_user_profile_Detail
                constants.archiveUser(Utitlity.sharedInstance.updated_user_profile_Detail)
                
                self.resetProfileView()
                self.getUserProfile()
                
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                Utitlity.sharedInstance.showAlert(self, message: "Request do not complete due to some sever error.")
            }
            Utitlity.sharedInstance.hideProgressHud()
            
        })
        
//        NetworkServices.sharedInstance.postWebServiceWith(paths.user_profile_update, params: param as [String:AnyObject], headers: [:], completion:
//            {(success,responseDict) in
//                if success {
//                    Utitlity.sharedInstance.showAlert(self, message: "Your profile has been updated successfully.")
//                    Utitlity.sharedInstance.user_profile = Utitlity.sharedInstance.updated_user_profile_Detail
//                    constants.archiveUser(Utitlity.sharedInstance.updated_user_profile_Detail)
//                    
//                    self.resetProfileView()
//                    
//                    _ = self.navigationController?.popViewController(animated: true)
//                }else{
//                    Utitlity.sharedInstance.showAlert(self, message: "Request do not complete due to some sever error.")
//                }
//                Utitlity.sharedInstance.hideProgressHud()
//        })

    }
    func updateFriendProfile(){
        Utitlity.sharedInstance.showProgressHud()
        
        let param = [
            "friend_id":String(profile_id),
            "user_id":String(Utitlity.sharedInstance.user_profile!.user_Id),
            "name":Utitlity.sharedInstance.updated_friend_detail!.friend_name,
            "email":Utitlity.sharedInstance.updated_friend_detail!.friend_Email,
            "picture":"",
            "dob":Utitlity.sharedInstance.updated_friend_detail!.friend_Dob,
            "facebook_link":Utitlity.sharedInstance.updated_friend_detail!.friend_Facebook_Id,
            "skype_id":Utitlity.sharedInstance.updated_friend_detail!.friend_Skype_Id,
            "phone":Utitlity.sharedInstance.updated_friend_detail!.friend_Mobile_no
        ]
        NetworkServices.sharedInstance.postWebServiceWith(paths.user_friend_profile_update, params: param as [String:AnyObject], headers: [:], completion:
            {(success,responseDict) in
                if success {
                    Utitlity.sharedInstance.showAlert(self, message: "Profile has been updated successfully.")
                    
                    self.resetProfileView()
                }else{
                    Utitlity.sharedInstance.showAlert(self, message: "Request do not complete due to some sever error.")
                }
                Utitlity.sharedInstance.hideProgressHud()
        })

    }
    func cancelUpdatedProfile(_ cell: ProfileTableViewCell) {
        if(isFromUserProfile == true){
            self.user_profile_Options_Array.removeLastObject()
        }else{
            self.friend_profile_Options_Array.removeLastObject()
        }
        
        isProfile_Editable = false
        self.tbl_profile.reloadData()
        Utitlity.sharedInstance.updated_user_profile_Detail = nil
        Utitlity.sharedInstance.updated_friend_detail = nil
    }
}

extension FriendProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
        self.updatedProfileCell.profile_ImgView.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
}
