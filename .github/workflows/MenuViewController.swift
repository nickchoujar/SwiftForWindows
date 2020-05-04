
//
//  MenuViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/23/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    let menuTitlesArray = ["","Invites","Calendar","Friends","History","Settings"]
    let menuIconsArray = ["","Create_Activity","Calendar_menu","friends","History_icon","setting_menu_icon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    //MARK :- TableView Delegate and Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitlesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifire = ""
        let cell : MenuTableViewCell!
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "menuLogoCell") as! MenuTableViewCell
        }else{
            cellIdentifire = "menuCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire) as! MenuTableViewCell
            cell.lblTitle.text = menuTitlesArray[indexPath.row]
            cell.icon_imgView.image = UIImage(named: menuIconsArray[indexPath.row])
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row>0 {
            return 70
        }
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let mapVc = self.storyboard?.instantiateViewController(withIdentifier: "mapVc")
            let nav   = Utitlity.setRootView(mapVc!)
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
        case 1:
            let mapVc = self.storyboard?.instantiateViewController(withIdentifier: "mapVc")
            let nav   = Utitlity.setRootView(mapVc!)
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
//        case 1:
//            let createActivityVc = self.storyboard?.instantiateViewController(withIdentifier: "createVc")
//            let nav   = self.setRootView(createActivityVc!)
//            self.revealViewController().pushFrontViewController(nav, animated: true)
//            break
        case 2:
            //Calander
            let calendarVc = self.storyboard?.instantiateViewController(withIdentifier: "calendarVc")
            let nav   = Utitlity.setRootView(calendarVc!)
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
        case 3:
            
            let friendsVc = self.storyboard?.instantiateViewController(withIdentifier: "friendsVc")
            let nav   = Utitlity.setRootView(friendsVc!)
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
        case 4:
            //historyVc
            let historyVc = self.storyboard?.instantiateViewController(withIdentifier: "historyVc")
            let nav   = Utitlity.setRootView(historyVc!)
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
//        case 5:
//            //Terms of Use
//            let termsVc = self.storyboard?.instantiateViewController(withIdentifier: "termsVc")
//            let nav   = Utitlity.setRootView(termsVc!)
//            self.revealViewController().pushFrontViewController(nav, animated: true)
//            break
        case 5:
            let settingsVc = self.storyboard?.instantiateViewController(withIdentifier: "settingsVc")
            let nav   = Utitlity.setRootView(settingsVc!)
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
        default:
            break
        }
    }
    
}
