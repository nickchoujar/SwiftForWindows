//
//  Events_ListView.swift
//  CatchUp
//
//  Created by Macbook on 12/25/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class Events_ListView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    var parent: AnyObject!
    
    var eventsListArray : NSMutableArray = []
    @IBOutlet var tbl_EventList : UITableView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //MARK :- TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventListCell") as! EventsList_TableViewCell
        let event = eventsListArray[indexPath.row] as! Event
        cell.lbl_EventName.text = event.event_name!
        cell.lblEvent_Restaurant.text = event.venue_address
        cell.lblEvent_Date.text = event.event_date + " " + event.event_time
        
        if event.event_Picture != nil && event.event_Picture != "" {
            
            cell.event_ImageView.af_setImage(withURL: URL.init(string: event.event_Picture)!, placeholderImage: UIImage(named:"placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), completion: { (dataResponse) in
                
                
            })
        }
        else {
        
            cell.event_ImageView.image = UIImage(named: "placeholder.png")
        }
        
        if(event.attendingStatus == 1){
            cell.lblEvent_Type.text = "Attending"
            cell.lblEvent_Type.textColor = UIColor.green
        }
        else if(event.attendingStatus == 2){
            cell.lblEvent_Type.text = "Not Attending"
            cell.lblEvent_Type.textColor = UIColor.red
        }
        else if(event.attendingStatus == 3){
            cell.lblEvent_Type.text = "Maybe"
            cell.lblEvent_Type.textColor = UIColor.orange
        }
        else if(event.attendingStatus == 1000){
            cell.lblEvent_Type.text = "Organiser"
            cell.lblEvent_Type.textColor = UIColor.white
        }
        else{
            cell.lblEvent_Type.text = "Not Set"
            cell.lblEvent_Type.textColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let event = eventsListArray[indexPath.row] as! Event
     
        parent.performSegue(withIdentifier: "EventDetailSegue", sender: event)
        
//        parent.perform
    }
    

    
}
