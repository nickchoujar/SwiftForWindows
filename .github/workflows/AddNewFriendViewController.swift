//
//  AddNewFriendViewController.swift
//  CatchUp
//
//  Created by Macbook on 1/18/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import DatePickerDialog
import MMPickerView
import TPKeyboardAvoiding;


class AddNewFriendViewController: UIViewController {

    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var txt_fName: UITextField!
    @IBOutlet weak var txt_Address: UITextField!
    @IBOutlet weak var txt_Dob: UITextField!
    @IBOutlet weak var txt_fb_Id: UITextField!
    @IBOutlet weak var txt_skype_id: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_cell_no: UITextField!
    @IBOutlet weak var txt_Group: UITextField!
    @IBOutlet weak var friend_imgView: UIImageView!
    @IBOutlet weak var btn_remove_ImgView: UIButton!
    
    
    var groupdArray = ["Friend","Family"]
    var selectGroupIndex =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add New Friend"

        // Do any additional setup after loading the view.
        txt_Dob.delegate = self
        txt_Group.delegate = self
        
        friend_imgView.layer.cornerRadius = friend_imgView.frame.size.width/2
        friend_imgView.clipsToBounds = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(UIImage(named:"backIcon"), target: self, action: #selector(AddNewFriendViewController.popView))
        
    }
    func popView()  {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - helper functions
    
    func resignAllTextFields() {
    
        txt_fName.resignFirstResponder()
        txt_Address.resignFirstResponder()
        txt_Dob.resignFirstResponder()
        txt_fb_Id.resignFirstResponder()
        txt_skype_id.resignFirstResponder()
        txt_email.resignFirstResponder()
        txt_cell_no.resignFirstResponder()
        txt_Group.resignFirstResponder()
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
    @IBAction func btn_removeImage_Action(_ sender: Any) {
        btn_remove_ImgView.isHidden = true
        friend_imgView.image = nil
        friend_imgView.isHidden = true
        
    }
    
    @IBAction func btn_uploadImage_Action(_ sender: Any) {
        self.showImageTakingOptions()
    }
    
    @IBAction func btn_Save_Action(_ sender: Any) {
        if checkValidationToCreateFriend() {
            
            if txt_email.text?.isValidEmail == false {
                Utitlity.sharedInstance.showAlert(self, message: constants.Invalid_Email)
                return
            }
            
            Utitlity.sharedInstance.showProgressHud()
            
            let param = [
                "user_id":String(Utitlity.sharedInstance.user_profile!.user_Id),
                "group_id":selectGroupIndex,
                "name":txt_fName.text!,
                "email":txt_email.text!,
                "phone":txt_cell_no.text!,
                "address":txt_Address.text!,
                "dob":txt_Dob.text!,
                "facebook_link":txt_fb_Id.text!,
                "skype_id":txt_skype_id.text!,
                "created_by":Utitlity.sharedInstance.user_profile!.user_name,
            ]
            NetworkServices.sharedInstance.uploadImageWithparams(paths.user_friend, img: friend_imgView.image!, params: param as [String : AnyObject], completion: { (success, responseDict) in
                if success {
                    // Post notification
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    Utitlity.sharedInstance.showAlert(self, message: "Request do not complete due to some sever error.")
                }
                Utitlity.sharedInstance.hideProgressHud()
            })

        }else{
            Utitlity.sharedInstance.showAlert(self, message: constants.AllFieldsRequired)
        }
    
    }
    
    
    func checkValidationToCreateFriend() -> Bool {
        
        if (txt_fName.text?.characters.count)! < 1 {
            
            Utitlity.sharedInstance.showAlert(self, message: constants.validationNameRequired)
            return false
        }
        
        if (txt_email.text?.characters.count)! < 1 {
         
            Utitlity.sharedInstance.showAlert(self, message: constants.validationEmailRequired)
            return false
        }
        
        if((txt_Address.text?.characters.count)! < 1){
           txt_Address.text = " "
        }
        

        return true
    }
}


extension AddNewFriendViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
        friend_imgView.image = image
        friend_imgView.isHidden = false
        btn_remove_ImgView.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewFriendViewController: UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 2 {
        
            self.resignAllTextFields()
            DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
                (date) -> Void in
                if date !=  nil {
                    self.txt_Dob.text = "\(date!.toString())"
                }
            }
            
            return false
        }
        else if textField.tag == 7 {
        
            self.resignAllTextFields()
            MMPickerView.showPickerView(in: self.view, withStrings: groupdArray, withOptions: ["MMValueY":"5"], withWidth:self.view.frame.size.width, completion:
                {(selectedValue) in
                    self.txt_Group.text = selectedValue
                    self.selectGroupIndex    = String(describing: self.groupdArray.index(of: selectedValue!)!+1)
            })
            
            return false
        }
        else {
        
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print("End: \(self.scrollView.contentInset.top)")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("Start: \(self.scrollView.contentInset.top)")
        
        if textField.tag == 2 {
            textField.resignFirstResponder()
        }
        else if textField.tag == 6 {
        
            let offset = self.scrollView.contentOffset
            
            self.scrollView.setContentOffset(CGPoint(x: offset.x, y: offset.y + 100), animated: true)
        }
        else if textField.tag == 7 {
            textField.resignFirstResponder()
        }
    }
}

