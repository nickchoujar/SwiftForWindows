//
//  SignUpViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/21/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SignUpViewDelegate {

    func signUpSuccessfull(email: String, password: String)
}

class SignUpViewController: UIViewController {

    var popupController:CNPPopupController?
    @IBOutlet weak var loginOptionsView: LoginOptionsView!
    
    var delegate: SignUpViewDelegate!
    
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
    
    //MARK :- Button Actions
    
    @IBAction func BtnSignUp_Action(_ sender: Any) {
        
        self.loginOptionsView.resignTextFieldResponder()
        
         Utitlity.sharedInstance.showProgressHud()
        let errorMessage = loginOptionsView.isRequiredFieldsCompleted(self)
        if (errorMessage == "") {
            self.signUpUserWithDetail()
            
        }else{
            Utitlity.sharedInstance.hideProgressHud()
            self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: errorMessage)
        }
    }
    
    func signUpUserWithDetail() {
        let params = [
            "user_fullname" :loginOptionsView.txt_UserName.text!,
            "user_phone"    :" ",
            "user_email"    :loginOptionsView.txt_Email.text!,
            "user_password" :loginOptionsView.txt_Password.text!
        ]
        NetworkServices.sharedInstance.postWebServiceWith(paths.user_register, params: params as [String : AnyObject] , headers: [:], completion: { (success, responseDict) in
            if success {
//                self.btnCancel_Action(Any.self)
                
                self.dismiss(animated: true, completion: { 
                    if let delegate = self.delegate {
                        
                        delegate.signUpSuccessfull(email: self.loginOptionsView.txt_Email.text!, password: self.loginOptionsView.txt_Password.text!)
                    }
                })
            }else{
                let message:String  = responseDict["message"] as! String;
                self.showPopupWithStyle(CNPPopupStyle.actionSheet, message: message)
            }
           Utitlity.sharedInstance.hideProgressHud()
            
        })
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        _ = self.dismiss(animated: true, completion: nil)
    }

    
    //MARK :- Custome Alert
    func showPopupWithStyle(_ popupStyle: CNPPopupStyle , message:String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let customView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-40, height: 100))
        customView.backgroundColor = UIColor.init(patternImage: UIImage(named: "logo_bg")!)
        customView.layer.cornerRadius = 5
        
        let title = NSAttributedString(string: message, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSParagraphStyleAttributeName: paragraphStyle])
        
        let button = CNPPopupButton.init(frame: CGRect(x: customView.frame.size.width-30, y: 5, width: 15, height: 15))
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
        titleLabel.frame     = CGRect(x: 10, y:imageView.frame.origin.y+imageView.frame.size.height+5 , width: customView.frame.size.width-20, height: 30)
        
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
    
}

extension SignUpViewController : CNPPopupControllerDelegate {
    
    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        print("Popup controller will be dismissed")
        
        self.loginOptionsView.resetTextField()
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
}
