//
//  ScheduleTableViewCell.swift
//  CatchUp
//
//  Created by Macbook on 1/20/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import DatePickerDialog

protocol ScheduleTableViewCellDelegate {
    
    func didAddSchedule(forCell cell: ScheduleTableViewCell, atRow row: Int, schedule: Schedule)
    func didDeleteSchedule(forCell cell: ScheduleTableViewCell, atRow row: Int, schedule: Schedule)
}

class ScheduleTableViewCell: UITableViewCell,UITextFieldDelegate {

//    var parentView: ScheduleViewController!
    var parentView: Any!
    
    var delegate: ScheduleTableViewCellDelegate!
    
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_Time: UITextField!
    @IBOutlet weak var doneCancelButton: UIButton!
    
    var selectedSchadule : Schedule!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didDoneCancelButtonPressed(_ sender: UIButton) {
    
        if txt_Time.text != "" && txt_title.text != "" {
        
            if sender.tag == 1 {
                
                self.doneCancelButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
                self.doneCancelButton.tag = 2
                
                self.txt_title.isEnabled = false
                self.txt_Time.isEnabled = false
                
                self.selectedSchadule.sch_Time = self.txt_Time.text
                self.selectedSchadule.sch_Activity = self.txt_title.text
                
                if let delegate = self.delegate {
                    
                    delegate.didAddSchedule(forCell: self, atRow: self.txt_title.tag, schedule: self.selectedSchadule)
                }
                
            }
            else {
                
                self.doneCancelButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                self.doneCancelButton.tag = 1
                
                self.selectedSchadule.sch_Time = self.txt_Time.text
                self.selectedSchadule.sch_Activity = self.txt_title.text
                
                self.txt_title.isEnabled = true
                self.txt_Time.isEnabled = true
                
                if let delegate = self.delegate {
                    
                    delegate.didDeleteSchedule(forCell: self, atRow: self.txt_title.tag, schedule: self.selectedSchadule)
                }
            }
        }
        else {
        
            if parentView != nil {
             
                Utitlity.sharedInstance.showAlert(parentView as! UIViewController, message: "Please fill all fields.")
            }   
        }
    }
    
    
    //MARK:- TextFields Delegate methods

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txt_Time {
            
            self.txt_title.resignFirstResponder()
            
            DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
                (date) -> Void in
                if date != nil {
                    self.txt_Time.text = "\(date!.toTimeString())"
                }
            }
            
            return false
        }
        
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txt_Time {
            
            self.txt_title.resignFirstResponder()
            
        }
        else {
        
            self.txt_Time.resignFirstResponder()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
        selectedSchadule.sch_Time = txt_Time.text!
        selectedSchadule.sch_Activity = txt_title.text!
        print(selectedSchadule.sch_Time+"and"+selectedSchadule.sch_Activity)
        
    }
}
