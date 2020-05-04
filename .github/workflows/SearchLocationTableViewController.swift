//
//  SearchLocationTableViewController.swift
//  CatchUp
//
//  Created by Macbook on 1/20/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit

class SearchLocationTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var locationsArray : NSMutableArray = []
    
    @IBOutlet weak var tbl_location: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if self.locationsArray.count > 0 {
            
            self.tbl_location.reloadData()
        }
        
//        self.getNearesLocations()
    }

    func getNearesLocations() {
        Utitlity.sharedInstance.showProgressHud()
//        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDKvD9019JdUOR8RGrBvzuIfldeGm8vKmQ&location=31.56685,74.54686&radius=10000&type=restaurant,movie_theater&rankby=prominence&sensor=true"
        let strlatLong = "\(Utitlity.sharedInstance.user_current_location.coordinate.latitude)"+","+"\(Utitlity.sharedInstance.user_current_location.coordinate.longitude)"
        let str_url = String(format: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDKvD9019JdUOR8RGrBvzuIfldeGm8vKmQ&location=%@&radius=10000&type=restaurant,movie_theater&rankby=prominence&sensor=true", strlatLong)
        NetworkServices.sharedInstance.getWebServiceWith(str_url, params: [:]) { (success, responseDict) in
            if success {
                let results_Array = responseDict["results"] as! NSArray
                if results_Array.count > 0 {
                    for result_dict in results_Array as! [NSDictionary] {

                        let geomateryDict = result_dict["geometry"] as! NSDictionary
                        let locationDict  = geomateryDict["location"] as! NSDictionary
                        let locationName = result_dict["name"] as! String
                        let locationAddress = result_dict["vicinity"] as! String
                        var locationRating = ""
                        if result_dict.object(forKey: "rating") != nil {
                           locationRating  = String(describing: result_dict["rating"]!)
                        }
                        
                        let location = NearestLocation()
                        location.loc_Name = locationName
                        location.loc_address = locationAddress
                        location.loc_rate    = locationRating
                        location.loc_img_url = result_dict["icon"] as! String
                        location.loc_lat     = String(describing: locationDict["lat"]!)
                        location.loc_long     = String(describing: locationDict["lng"]!)
                        
                        self.locationsArray.add(location)
                    }
                    self.tbl_location.reloadData()
                }
            }
            Utitlity.sharedInstance.hideProgressHud()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationsArray.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchLocationCell", for: indexPath) as! SearchLocationTableViewCell

        // Configure the cell...
        let loc    = locationsArray[indexPath.row] as! NearestLocation
        cell.configureCell(loc)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utitlity.sharedInstance.selected_location = locationsArray[indexPath.row] as? NearestLocation
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
