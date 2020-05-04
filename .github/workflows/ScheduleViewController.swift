//
//  ScheduleViewController.swift
//  CatchUp
//
//  Created by Macbook on 1/20/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

protocol ScheduleViewControllerDelegate {
    
    
}

class ScheduleViewController: UITableViewController {
    
    @IBOutlet weak var tbl_schedule : UITableView!
    
    var isAddedSuccessful: Bool = true
    var delegate: ScheduleViewControllerDelegate!
    
    var schedules_Array : NSMutableArray = [Schedule()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Schedules"
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ScheduleViewController.addNewActivity))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(UIImage(named:"backIcon"), target: self, action: #selector(ScheduleViewController.popView))
        
        if Utitlity.sharedInstance.schedules_Array.count > 0 {
            
            for schedule in Utitlity.sharedInstance.schedules_Array as NSArray as! [Schedule] {
             
                self.schedules_Array.add(schedule)
            }
            
            self.tableView.reloadData()
        }
        
    }
    func popView()  {

        print(Utitlity.sharedInstance.schedules_Array)
        
        for arrayValue in Utitlity.sharedInstance.schedules_Array {
            
            let schedule: Schedule = arrayValue as! Schedule
            
            print(schedule.sch_Activity)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    func addNewActivity()  {
        
        if self.isAddedSuccessful {
            
            self.isAddedSuccessful = false
         
            self.schedules_Array.add(Schedule())
            tbl_schedule.reloadData()
            tbl_schedule.scrollToRow(at: IndexPath(row: self.schedules_Array.count-1 , section:0), at: .bottom, animated: true)
        }
        else {
        
            Utitlity.sharedInstance.showAlert(self, message: "Please first add previous schedule.")
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

    //MARK:- TableView Delegate and Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedules_Array.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {//just title for cells
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleTitle", for: indexPath)
            
            return cell
        }else{//activity and time setting cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
            
            cell.delegate = self
            cell.parentView = self
            
            let schadule = self.schedules_Array[indexPath.row] as! Schedule
            
            cell.selectedSchadule = schadule
            
            cell.txt_title.tag = indexPath.row
            cell.txt_Time.tag  = indexPath.row
            
            
            cell.txt_Time.text = schadule.sch_Time
            cell.txt_title.text = schadule.sch_Activity
            
            if cell.txt_title.text != "" && cell.txt_Time.text != "" {
                
                cell.doneCancelButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
                cell.doneCancelButton.tag = 2
                
                cell.txt_title.isEnabled = false
                cell.txt_Time.isEnabled = false
            }
            else {
            
                cell.doneCancelButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                cell.doneCancelButton.tag = 1
                
                cell.txt_title.isEnabled = true
                cell.txt_Time.isEnabled = true
            }
            
            
            return cell

        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row>0 {
            return 60
        }
        return 44
    }
}

extension ScheduleViewController: ScheduleTableViewCellDelegate {

    func didAddSchedule(forCell cell: ScheduleTableViewCell, atRow row: Int, schedule: Schedule) {
       
        Utitlity.sharedInstance.schedules_Array.add(schedule)
        
        self.schedules_Array.replaceObject(at: row, with: schedule)
        
        self.isAddedSuccessful = true
    }
    
    func didDeleteSchedule(forCell cell: ScheduleTableViewCell, atRow row: Int, schedule: Schedule) {
        
        Utitlity.sharedInstance.schedules_Array.remove(schedule)
        self.schedules_Array.remove(schedule)
        
        self.tableView.reloadData()
        self.isAddedSuccessful = true
    }
}
