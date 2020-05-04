//
//  SettingsViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/27/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let titlesArray =  ["Profile", "Reset Password", "Logout", "Close Account"]
    let iconsArray  =  ["profile_icon", "password_icon", "logout-Icon", "delete-Icon"]
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Side bar menu setting
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)), for: .touchUpInside)
 self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.revealViewController() != nil {
            
            if Utitlity.getLastLogoutPressed() == true {
                
                Utitlity.setLastLogoutPressed(false)
                
                let mapVc = self.storyboard?.instantiateViewController(withIdentifier: "mapVc")
                let nav   = Utitlity.setRootView(mapVc!)
                self.revealViewController().pushFrontViewController(nav, animated: true)
            }
        }
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

    //Mark :- TableView Delegate and Datasource Methods. 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsTableViewCell
        cell.titleLable.text = titlesArray[indexPath.row]
        cell.icon_ImgView.image = UIImage(named:iconsArray[indexPath.row])
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "friendProfileVc") as! FriendProfileViewController
            profileVc.profile_id = Int64(Utitlity.sharedInstance.user_profile!.user_Id)
            profileVc.isFromUserProfile = true
            self.navigationController?.pushViewController(profileVc, animated: true)
            

            break
        case 1:
            let resetVc = self.storyboard?.instantiateViewController(withIdentifier: "resetVc") as! ResetViewController
            self.navigationController?.pushViewController(resetVc, animated: true)
            break
        case 2:
            
            Utitlity.sharedInstance.showAlert(self, message: "Are you sure you want to logout?", confirmActionTitle: "YES", cancelActionTitle: "NO", confirmAction: { (confirmAction) in
                
                
                Utitlity.setLastLogoutPressed(true)
                UserDefaults.standard.set(false, forKey: "isUserLoging")
                let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
                self.present(loginVc, animated: true, completion: nil)
                
            }, cancelAction: { (cancelAction) in
                
                
            })
            
            break
        case 3:
            
            Utitlity.sharedInstance.showAlert(self, message: "Are you sure you want to delete your account?", confirmActionTitle: "YES", cancelActionTitle: "NO", confirmActionStyle: .destructive, cancelActionStyle: .default, confirmAction: { (confirmAction) in
                
                let params  = [
                    "user_id" : String(Utitlity.sharedInstance.user_profile!.user_Id),
                    ]
                
                Utitlity.sharedInstance.showProgressHud()
                NetworkServices.sharedInstance.postWebServiceWith(paths.delete_user_account, params: params as [String : AnyObject], headers: [:], completion: { (success, responseDict) in
                    if (success){
                        
                        self.clearDB();
                        
                        UserDefaults.standard.set(false, forKey: "isUserLoging")
                        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
                        self.present(loginVc, animated: true, completion: nil)
                        
                        
                    }else{
                        
                        //  self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: constants.wrong_usernameorPassword_message, textLabelHeight:40.0)
                        
                    }
                    Utitlity.sharedInstance.hideProgressHud()
                })
                
            }, cancelAction: { (cancelAction) in
                
            })
            
            break


            
        default:
            break
        }
    }
    
    func clearDB() {
    
        PhoneContactList.mr_truncateAll()
        FriendList.mr_truncateAll()
    }
}
