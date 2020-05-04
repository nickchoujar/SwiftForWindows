//
//  ResetViewController.swift
//  CatchUp
//
//  Created by Macbook on 1/14/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {

    @IBOutlet weak var txt_old_Password: UITextField!
    @IBOutlet weak var txt_New_Password: UITextField!
    @IBOutlet weak var txt_Confrim_Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    //MARK:- Buttons Actions
    @IBAction func btn_Submit_Action(_ sender: Any) {
        
        txt_New_Password.resignFirstResponder()
        txt_old_Password.resignFirstResponder()
        txt_Confrim_Password.resignFirstResponder()
        
        if (txt_old_Password.text?.characters.count)!>0 && (txt_New_Password.text?.characters.count)!>0 && (txt_Confrim_Password.text?.characters.count)!>0 {
            if txt_New_Password.text! == txt_Confrim_Password.text! {
                Utitlity.sharedInstance.showProgressHud()
                let params = [
                    "user_id":String(describing:Utitlity.sharedInstance.user_profile!.user_Id),
                    "old_password":txt_old_Password.text!,
                    "new_password":txt_New_Password.text!
                ]
                NetworkServices.sharedInstance.postWebServiceWith(paths.update_password, params: params as [String:AnyObject], headers: [:], completion: { (success, responseDict) in
                    if (success) {
                        
                        let message: String = responseDict["message"] as! String
                        
                        Utitlity.sharedInstance.showAlert(self, message: message, completion: { (alertAction) in
                        
                            _ = [self.navigationController?.popViewController(animated: true)]
                            
                        })
                        
                    }else{
                        
                    }
                    Utitlity.sharedInstance.hideProgressHud()
                })
            }else{
                Utitlity.sharedInstance.showAlert(self, message: constants.password_DoNot_match)
            }
        }else{
            Utitlity.sharedInstance.showAlert(self, message: constants.AllFieldsRequired)
        }
    }

    @IBAction func btn_Cancel_Action(_ sender: Any) {
         _ = [self.navigationController?.popViewController(animated: true)]
    }
}
