//
//  LoginOptionsView.swift
//  CatchUp
//
//  Created by Macbook on 12/21/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class LoginOptionsView: UIView,UITextFieldDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var txt_UserName : UITextField!
    @IBOutlet var txt_Password : UITextField!
    @IBOutlet var txt_Email    : UITextField!
    @IBOutlet var txt_Mobile   : UITextField!
    @IBOutlet var lblUname     : UILabel!
    @IBOutlet var lblPassword  : UILabel!
    @IBOutlet var lblEmail     : UILabel!
    @IBOutlet var lblMobile    : UILabel!
    
    func resetTextField() {
        
        if txt_UserName != nil {
            
            txt_UserName.text = ""
        }
        
        if txt_Password != nil {
            
            txt_Password.text = ""
        }
        
        if txt_Email != nil {
            
            txt_Email.text = ""
        }
        
        if txt_Mobile != nil {
            
            txt_Mobile.text = ""
        }
    }
    
    func resignTextFieldResponder() {
    
        if txt_UserName != nil {
        
            txt_UserName.resignFirstResponder()
        }
        
        if txt_Password != nil {
        
            txt_Password.resignFirstResponder()
        }
        
        if txt_Email != nil {
        
            txt_Email.resignFirstResponder()
        }
        
        if txt_Mobile != nil {
         
            txt_Mobile.resignFirstResponder()
        }
    }
    
    //MARK :- TextField delegate methonds
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(txt_UserName) {//show placehoder labels for username or password
            lblUname.isHidden = false
        }else if textField.isEqual(txt_Password){
            lblPassword.isHidden = false
        }else if textField.isEqual(txt_Email){
            lblEmail.isHidden = false
        }else if textField.isEqual(txt_Mobile){
            lblMobile.isHidden = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //hide placehoder labels for username or password if fields are empty
        if textField.isEqual(txt_UserName) && textField.text?.characters.count == 0 {
            lblUname.isHidden = true
        }else if textField.isEqual(txt_Password) && textField.text?.characters.count == 0{
            lblPassword.isHidden = true
        }else if textField.isEqual(txt_Email) && textField.text?.characters.count == 0{
            lblEmail.isHidden = true
        }else if textField.isEqual(txt_Mobile) && textField.text?.characters.count == 0{
            lblMobile.isHidden = true
        }
    }
    
    //MARK :- Check Validations 
    func isRequiredFieldsCompleted(_ controller:UIViewController) -> String {
        if txt_UserName.text?.trimWhiteSpaces().characters.count == 0 {

            return "Username is required"
        }else if txt_Email.text?.characters.count == 0 {
            return "Email is required"
        }else if !(txt_Email.text?.isValidEmail)! {
            return constants.Incorrect_Email_Formate
        }else if txt_Password.text?.characters.count == 0 {
            return "Password is required"
        }
        /*
        else if txt_Mobile.text?.characters.count == 0 {
            return "Mobile is required"
        }
        */
        
        return ""
    }
}
