//
//  UpdatePassword.swift
//  CatchUp
//
//  Created by Hammad Mujtaba on 21/8/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import Foundation


protocol UpdatePasswordDelegate {
    
    func updateButtonSubmitted(newPassword: String, code: String)
    func cancelUpdatePassword()

}



class UpdatePassword: UIView {


    var delegate: UpdatePasswordDelegate!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!

    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "UpdatePassword", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func btnSubmitPressed(_ sender: Any) {
    
        if (tfCode.text?.characters.count)!>0 && (tfNewPassword.text?.characters.count)!>0 {
            delegate.updateButtonSubmitted(newPassword:tfNewPassword.text!, code: tfCode.text!)
            
        }else{
           // Utitlity.sharedInstance.showAlert(self, message: constants.AllFieldsRequired)
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {
        
        self.removeFromSuperview()
            self.delegate.cancelUpdatePassword()
        
    }

}


