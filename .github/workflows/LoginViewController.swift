//
//  LoginViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/21/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import SVProgressHUD
import Contacts
import AddressBook


class LoginViewController: UIViewController, UpdatePasswordDelegate {
    
    var popupController:CNPPopupController?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var uView:UpdatePassword?
    var tempEmail:String = ""
    
    @IBOutlet weak var lbl_Invalid_userName: UILabel!
    @IBOutlet weak var lbl_Invalid_password: UILabel!
    
    @IBOutlet weak var usernameOption_View: LoginOptionsView!
    @IBOutlet weak var passwordUsername_View: LoginOptionsView!
    var contactTemp = [AnyObject]()
    
    //    var contactStore: CNContactStore?
    var addressBook: ABAddressBook?
    var contactsArray =  [[String:String]]()
    
    var bgOverlay:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if Utitlity.sharedInstance.user_profile != nil || UserDefaults.standard.bool(forKey: "isUserLoging") == false {
            let mapVc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.navigationController?.pushViewController(mapVc, animated: false)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.contactsArray = CatchupContacts.sharedInstance.importContactsFromPhone()
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
        
        if segue.identifier == "SignUpSegue" {
            
            let signUpViewController: SignUpViewController = segue.destination as! SignUpViewController
            
            signUpViewController.delegate = self
        }
     }
 
    
    //MARK :- Button Actions
    
    func showUpdatePasswordScreen(){
        
        
        self.coverOverlay()
        var view = UpdatePassword.instanceFromNib
        var updateView = view()
        uView = updateView as! UpdatePassword
        uView?.delegate = self
        
        updateView.frame = CGRect(x: 10, y: 50, width:updateView.frame.size.width, height: updateView.frame.size.height)
        
        self.view.addSubview(updateView)
    }
    
    func coverOverlay(){
        
        bgOverlay.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        bgOverlay.backgroundColor = UIColor.black
        bgOverlay.alpha = 0.95
        self.view.addSubview(bgOverlay)

    }
    
    func removeOverlay(){
        
        bgOverlay.removeFromSuperview()
        
    }
    
    func cancelUpdatePassword(){
        
      removeOverlay()
        
    }
    
    func updateButtonSubmitted(newPassword: String, code: String) {
        
        Utitlity.sharedInstance.showProgressHud()
        let params = [
           // "email":String(describing:Utitlity.sharedInstance.user_profile!.user_Id),
            "email":tempEmail,
            "code":code,
            "new_password":newPassword
        ]
        
        NetworkServices.sharedInstance.postWebServiceWith(paths.reset_Password, params: params as [String:AnyObject], headers: [:], completion: { (success, responseDict) in
            if (success) {
            
            //    Utitlity.sharedInstance.hideProgressHud()
                // _ = [self.navigationController?.popViewController(animated: true)]
                

                

                
            }else{
            
                
            }

            self.removeOverlay()
            let message:String  = responseDict["message"] as! String;
            
            self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: message, textLabelHeight:40.0)
            
            self.uView?.removeFromSuperview()

            Utitlity.sharedInstance.hideProgressHud()
            
        })
        
        
    }
    
    func loginWithParameters(_ params: [String: AnyObject]) {
        
        // A1648F5441BBC4EB720B18B04A276303BFFAEE145133893FB75A682ADF94F85D
        
        Utitlity.sharedInstance.showProgressHud()
        //Login User with email and Password
        NetworkServices.sharedInstance.postWebServiceWith(paths.user_login, params: params, headers: [:], completion: { (success, responseDict) in
            
            if (success) {
                
                let message:String  = responseDict["message"] as! String;
                
                self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: message, textLabelHeight:40.0)
                
                let userDict = responseDict["data"]
                if (userDict != nil) {
                    
                    let login_user = User(withDictionary: responseDict)
                    
                    Utitlity.sharedInstance.user_profile = login_user
                    constants.archiveUser(login_user)
                    UserDefaults.standard.set(true, forKey: "isUserLoging")
                    
                    self.dismiss(animated: true, completion: {

                        DispatchQueue.main.async {
                            () -> Void in
                            self.uploadUserContactInDB()
                            
                            // if had a Dynamic link value
                            if (UserDefaults.standard.string(forKey: "dynamiclink") != nil){
                                if (UserDefaults.standard.string(forKey: "dynamiclink") != ""){
                                    
                                    let newString = UserDefaults.standard.string(forKey: "dynamiclink")
                                    let linkPathArray: [String] = (newString?.components(separatedBy: "/"))!
                                    let category: String = linkPathArray[0]
                                    let categoryType: String = linkPathArray[1]
                                    let categoryLink: String = linkPathArray[2]
                                    
                                    if category == "Invitation" {
                                        
                                        if categoryType == "Friend" {
                                            
                                            self.appdelegate.addFriendToServerContacts(friend_id: categoryLink)
                                        }
                                        else if categoryType == "Event" {
                                            
                                            self.appdelegate.saveEventInviteesToServer(event_id: categoryLink)
                                            self.appdelegate.showEventDetailPage(withEventId: categoryLink)
                                        }
                                    }
                                   UserDefaults.standard.set("", forKey: "dynamiclink")
                                }
                            }
                        }
                    })
                    
                    
                    //                        let mapVc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    //                        self.navigationController?.pushViewController(mapVc, animated: true)
                }
            }
            else {
                
                let message:String  = responseDict["message"] as! String;
                
                self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: message, textLabelHeight:40.0)
            }
            Utitlity.sharedInstance.hideProgressHud()
        })

    }
    
    @IBAction func BtnLogin_Action(_ sender: Any) {
        
        self.usernameOption_View.resignTextFieldResponder()
        self.passwordUsername_View.resignTextFieldResponder()
        
        if self.validationsOk() {
            
            let params: [String: AnyObject]  = [
                "user_email" : usernameOption_View.txt_UserName.text! as AnyObject,
                "user_password" : passwordUsername_View.txt_Password.text! as AnyObject,
                //"device_token" : Utitlity.sharedInstance.device_token
                "device_token" : Utitlity.sharedInstance.device_token! as AnyObject
                //                "device_token" : "12345"
            ]
            self.loginWithParameters(params)
        }
        else {
            
            self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: constants.wrong_usernameorPassword_message, textLabelHeight:40)
        }
    }
    
    func validationsOk() -> Bool {
        if(usernameOption_View.txt_UserName.text?.characters.count == 0){
            lbl_Invalid_userName.text = constants.Invalid_Email
            return false
        }else if !(usernameOption_View.txt_UserName.text?.isValidEmail)!{
            lbl_Invalid_userName.text = constants.Invalid_Email
            return false
        }else{
            lbl_Invalid_userName.text = ""
        }
        if (passwordUsername_View.txt_Password.text?.characters.count == 0){
            lbl_Invalid_password.text = constants.Invalid_Password
            return false
        }else {
            lbl_Invalid_password.text = ""
            return true
        }
    }
    
    @IBAction func btnForgot_Action(_ sender: Any) {
        
        self.usernameOption_View.resignTextFieldResponder()
        self.passwordUsername_View.resignTextFieldResponder()
        
        let popUpVC = ForgotPasswordPopup(nibName: "ForgotPasswordPopup", bundle: nil)
        print(popUpVC.view.frame)
        let currentFrame: CGRect = popUpVC.view.frame
        popUpVC.view.frame = CGRect(x: currentFrame.origin.x, y: 30, width: currentFrame.size.width, height: currentFrame.size.height)
        popUpVC.delegate = self
        
        
        
        // self.view.addSubview(upView)
        
        //  let popUpVC = ForgotPasswordPopup(nibName: "ForgotPasswordPopup", bundle: nil)
        //  popUpVC.delegate = self
        self.setNewPopupSize(CGSize(width: currentFrame.size.width, height: currentFrame.size.height + 100), animated: true)
//        self.setNewPopupPosition(CGRect(x: 10, y: 30, width: currentFrame.size.width, height: currentFrame.size.height))
    
        self.presentPopupViewController(popUpVC, animationType: MJPopupViewAnimationFade)
        
        
     //   showUpdatePasswordScreen()
    }
    
}

extension LoginViewController: SignUpViewDelegate {

    func signUpSuccessfull(email: String, password: String) {
        
        let params: [String: AnyObject]  = [
            "user_email" : email as AnyObject,
            "user_password" : password as AnyObject,
            //"device_token" : Utitlity.sharedInstance.device_token
            "device_token" : Utitlity.sharedInstance.device_token! as AnyObject
            //                "device_token" : "12345"
        ]
        
        self.loginWithParameters(params)
    }
}

extension LoginViewController : ForgotPopupDelegate{
    func popUpCancelButtonClicked(_ popUpViewController: ForgotPasswordPopup!) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    func popupSubmitButtonClicked(_ popUpViewController: ForgotPasswordPopup!, withEmal email: String!) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        if email.isValidEmail {
            self.forgotPassword(email!)
        }else{
            self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: constants.Incorrect_Email_Formate, textLabelHeight:50)
        }
        
    }
    
    func forgotPassword(_ email:String) {
        let param = ["user_email":email]
        self.tempEmail = email
        Utitlity.sharedInstance.showProgressHud()
        NetworkServices.sharedInstance.postWebServiceWith(paths.forgot_password, params: param as [String:AnyObject] , headers: [:], completion:{(success,responseDict) in
            if success {
                self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: constants.check_Email_Message, textLabelHeight:100.0)
                self.showUpdatePasswordScreen()
            }else{
                self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: constants.email_Not_Exist, textLabelHeight:50.0)
            }
            Utitlity.sharedInstance.hideProgressHud()
        })
    }
}
extension LoginViewController : CNPPopupControllerDelegate {
    //MARK :- Custome Alert
    func showPopupWithStyle(_ popupStyle: CNPPopupStyle , message:String, textLabelHeight:CGFloat) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let customView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-40, height: 100))
        customView.backgroundColor = UIColor.init(patternImage: UIImage(named: "logo_bg")!)
        customView.layer.cornerRadius = 5
        
        let title = NSAttributedString(string: message, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSParagraphStyleAttributeName: paragraphStyle])
        
        let button = CNPPopupButton.init(frame: CGRect(x: customView.frame.size.width-30, y: 10, width: 15, height: 15))
        button.setImage(UIImage(named:"close"), for: UIControlState())
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            print("Block for button: \(button.titleLabel?.text)")
        }
        
        let imageView = UIImageView.init(image: UIImage.init(named: "exclamation"))
        imageView.frame = CGRect(x: (customView.frame.size.width/2)-10, y: 20, width: 40, height: 40)
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        titleLabel.textColor =  UIColor(red: 24.0/255.0, green: 124.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        titleLabel.frame     = CGRect(x: 10, y:imageView.frame.origin.y+imageView.frame.size.height+5 , width: customView.frame.size.width-20, height: textLabelHeight)
        
        //update custom view height with label hight
        var frame = customView.frame
        frame.size.height = titleLabel.frame.origin.y+titleLabel.frame.size.height+10
        customView.frame  = frame
        
        customView.addSubview(button)
        customView.addSubview(imageView)
        customView.addSubview(titleLabel)
        
        let popupController = CNPPopupController(contents:[customView])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = popupStyle
        popupController.theme.backgroundColor = UIColor.black
        popupController.delegate = self
        self.popupController = popupController
        popupController.present(animated: true)
    }
    
    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        print("Popup controller will be dismissed")
        
        self.usernameOption_View.resetTextField()
        self.passwordUsername_View.resetTextField()
        
        //        UserDefaults.standard.set(true, forKey: "isUserLoging")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginSuccessfull"), object: nil)
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
    func uploadUserContactInDB() {
        
        if contactsArray.count > 0 {
            
            CatchupContacts.sharedInstance.uploadUserContactInDB(contactsArray: self.contactsArray, completion: { (success, responseDict) in
                
                
            })
        }
    }
}



