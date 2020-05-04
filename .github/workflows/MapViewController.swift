//
//  MapViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/23/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mapView : GMSMapView!
    @IBOutlet var mapParentView: UIView!
    @IBOutlet weak var eventsList_Container: Events_ListView!
    @IBOutlet weak var btnEvent_List: UIButton!
    @IBOutlet weak var btn_Public_Event : UIButton!
    @IBOutlet weak var btn_Private_Event : UIButton!
    @IBOutlet weak var btn_login : UIButton!
    @IBOutlet weak var txt_search : UITextField!
    @IBOutlet weak var btn_new_event : UIButton!

    var locationManager = CLLocationManager()
    var myLocation = CLLocation()
    var didFindLocation : Bool = false
    var isPublicEvent: Bool = true
    
    var isPublicService: Bool = false
    var isPrivateService: Bool = false
    
    var publicEventsArray : NSMutableArray = []
    var privateEventsArray : NSMutableArray = []
//    var mapView : GMSMapView!
    
    var markers: [GMSMarker] = [GMSMarker]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //set login button circle
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePrivateEventsFromServer), name: NSNotification.Name(rawValue: "NotificationMapEventFromServer"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginSuccessfullNotification(_:)), name: NSNotification.Name(rawValue: "NotificationLoginSuccessfull"), object: nil)
        
        // Do any additional setup after loading the view.
        //Side bar menu setting
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        self.updateViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isUserLoging") == false {
            
        }else{
//            getMyCurrentEvents()
            
//            AppDelegate.appDelegate.initializeNotificationServices()
        }
        
        AppDelegate.appDelegate.initializeNotificationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewController()
    }
    
    func updateViewController() {
    
        btn_login.layer.cornerRadius = btn_login.frame.size.width/2
        btn_login.layer.masksToBounds = true
        
        //round the corners of options buttons
        self.btn_Public_Event.layer.cornerRadius    = 5.0
        self.btn_Private_Event.layer.cornerRadius   = 5.0
        
        self.btn_Public_Event.backgroundColor = constants.getThemeForegroundColor()
        self.btn_Private_Event.backgroundColor = constants.getThemeBackgroundColor()
        
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self;
        
        //map update with user current location
        self.updateLocation()
        
        self.eventsList_Container.parent = self
    }
    
    func setViewController() {
    
        if UserDefaults.standard.bool(forKey: "isUserLoging") == false {
            menuButton.isHidden = true
            btn_login.isHidden = false
            btn_new_event.isHidden = true
        }else{
            menuButton.isHidden = false
            btn_login.isHidden = true
            btn_new_event.isHidden = false
            if isPublicEvent {
            
                self.getPublicEventsFromServer()
            }
            else {
            
                self.getMyCurrentEvents()
            }
        }
    }
    
    func updateLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "EventDetailSegue" {
            
            let eventDetailViewController: EventDetailViewController = segue.destination as! EventDetailViewController
           // eventDetailViewController.dontShowAttendControls = 1
            eventDetailViewController.selected_Event = (sender as! Event)
        }
        
     }
 
    
    //MARK :- Buttons Actions
    @IBAction func btnNewEvent(_ sender: Any) {
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
        self.present(loginVc, animated: true, completion: nil)
    }

    @IBAction func btnPublicEvents_Action(_ sender: Any) {
        
        self.isPublicEvent = true
        
        self.btn_Public_Event.backgroundColor = constants.getThemeForegroundColor()
        self.btn_Private_Event.backgroundColor = constants.getThemeBackgroundColor()
        
        self.eventsList_Container.eventsListArray = self.publicEventsArray;
        self.setEventsOnMap()
        
        self.getPublicEventsFromServer()
    }
    
    @IBAction func btnPrivateEvents_Action(_ sender: Any) {
    
        self.updatePrivateEventsFromServer()
    }
    
    @IBAction func btnEventList_Action(_ sender: Any) {
        if eventsList_Container.isHidden {
            btnEvent_List.setImage(UIImage(named:"map_view")!, for: .normal)
            eventsList_Container.isHidden = false
            txt_search.isHidden = true
        }else{
            btnEvent_List.setImage(UIImage(named:"list_view")!, for: .normal)
            eventsList_Container.isHidden = true
            txt_search.isHidden = false
        }
    }
    
    @IBAction func btn_login_Action (_ sender : Any) {
       
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "loginVc") as! LoginViewController
        self.present(loginVc, animated: true, completion: nil)
    }
    
    func loginSuccessfullNotification(_ notification: Notification) {
    
        self.setViewController()
        self.updateViewController()
    }
    
    //MARK: - Get Events against user location from server
    
    func getPublicEventsFromServer() {
        
       // if !self.isPublicService {
            
            self.isPublicService = true
        
            let params = [
                "user_id":String(describing: Utitlity.sharedInstance.user_profile!.user_Id),
              //  "late":String(describing:-33.887353),
              //  "long":String(describing:151.208096)
                "late":String(describing: myLocation.coordinate.latitude),
                "long":String(describing: myLocation.coordinate.longitude)
                
            ]
        
            Utitlity.sharedInstance.showProgressHud(message: "Searching for Indirect invites around you")
            NetworkServices.sharedInstance.postWebServiceWith(paths.user_venue_events, params: params as [String : AnyObject], headers: [:], completion:{(success,responseDict) in
                
                Utitlity.sharedInstance.hideProgressHud()
                if success {
                    let dataArray: [[String: Any]] = responseDict["data"] as! [[String: Any]]
                    if (dataArray.count)>0 {
                        self.eventsList_Container.eventsListArray = []
                        
                        if self.isPublicEvent == true {
                            
                            self.isPublicService = false
                            
                            for eventDict in dataArray {
                                
                                let event: Event = Event(responseDict: eventDict)
                                
                                self.markEventVenuesOnMapWith(event)
                                self.eventsList_Container.eventsListArray.add(event)
                            }
                            self.publicEventsArray = self.eventsList_Container.eventsListArray
                            
                            self.setEventsOnMap()
                        }
                    }
                }
            })
        }
   // }
    //MARK :- Get All Public Events if not user login
//    func getAllPublicEventFromServer()  {
//        NetworkServices.sharedInstance.getWebServiceWith(paths.all_public_evnets, params: [:], completion:{(success,responseDict) in
//            if success {
//                let dataArray = responseDict["data"]
//                if ((dataArray as AnyObject).count)!>0 {
//                    self.eventsList_Container.eventsListArray = []
//                    for eventDict in dataArray as! [AnyObject]{
//                        let event = Event(eventId: eventDict["event_id"] as! Int, address: eventDict["venue_address"] as! String, latitude: Double(eventDict["venue_late"] as! String)!, longitude: Double(eventDict["venue_long"] as! String)! , eventType: eventDict["event_type"] as! String, eventPic: eventDict["picture"] as! String, eName:eventDict["event_name"] as! String, date:(eventDict["date"] as! String).toDate("yyyy-MM-dd"), time:(eventDict["time"] as! String).toDate("H:mm:ss.SSS"))
//                        self.markEventVenuesOnMapWith(event)
//                        self.eventsList_Container.eventsListArray.add(event)
//                    }
//                    
//                    self.setEventsOnMap()
//                }
//            }
//        })
//    }

    func setEventsOnMap() {
    
        if self.eventsList_Container.eventsListArray.count > 0 {
            
            self.drawMarker()
        }
        else {
        
            self.mapView.clear()
        }
        
        self.eventsList_Container.tbl_EventList.reloadData()
    }
    
    func setPrivateEvents() {
        
        self.isPublicEvent = false
        
        self.btn_Public_Event.backgroundColor = constants.getThemeBackgroundColor()
        self.btn_Private_Event.backgroundColor = constants.getThemeForegroundColor()
        
        self.eventsList_Container.eventsListArray = self.privateEventsArray;
        self.setEventsOnMap()
        
    }
    
    func updatePrivateEventsFromServer() {
    
        Utitlity.sharedInstance.showProgressHud(message: "Retrieving your Direct invites")
        self.setPrivateEvents()
        self.getMyCurrentEvents()
    }
    
    func getMyCurrentEvents()  {
        
        if !self.isPrivateService {
            
            self.isPrivateService = true
        
            let params = [
                "user_id":String(describing: Utitlity.sharedInstance.user_profile!.user_Id)
            ]
            
            print(params)
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.eventsListArray.removeAll()
            NetworkServices.sharedInstance.postWebServiceWith(paths.my_current_events, params: params as [String : AnyObject], headers: [:], completion:{(success,responseDict) in
                Utitlity.sharedInstance.hideProgressHud()
                if success {
                    let dataArray = responseDict["data"]
                    if (dataArray?.count)!>0 {
                        self.eventsList_Container.eventsListArray = []
                        
                        if self.isPublicEvent == false {
                            
                            self.isPrivateService = false
                            
                            for eventDict in dataArray as! [AnyObject]{
                                
                                let event: Event = Event(responseDict: eventDict as! Dictionary<String, Any>)
                                
                                self.markEventVenuesOnMapWith(event)
                                self.eventsList_Container.eventsListArray.add(event)
                                appdelegate.eventsListArray.append(event)
                                
                            }
                            
                            appdelegate.eventsListArray.sort(by: { (event1, event2) -> Bool in
                                if(event1.event_id > event2.event_id){
                                    return false
                                }
                                else{
                                    return true
                                }
                            })
                            
                            self.eventsList_Container.eventsListArray.sort(using: [NSSortDescriptor(key: "eventDateTime", ascending: true)])
                            
                            self.privateEventsArray = self.eventsList_Container.eventsListArray
                        
                            
                            
                            self.setEventsOnMap()
                        }
                    }
                }
                else {
                    
                    self.isPrivateService = false
                }
            })
        }
    }

    
    //MARK :- Set marker on map
    func markEventVenuesOnMapWith(_ event: Event) {
        // Creates a marker in the center of the map.

        let position = CLLocationCoordinate2D(latitude: event.venue_late, longitude: event.venue_long)
        
        let marker = GMSMarker(position: position)

        marker.title = event.event_name
        marker.snippet = event.venue_address
        marker.userData = String(event.event_id)
        
        marker.icon = GMSMarker.markerImage(with: constants.getThemeTextColor()) //UIImage(named: "userIcon")
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = nil
        
        markers.append(marker)
    }
    
    func drawMarker() {
    
        self.mapView.clear()
        
        if self.mapView != nil {
            
            for marker in self.markers {
                
                if marker.map == nil {
                    
                    DispatchQueue.main.async {
                        
                        marker.map = self.mapView
                    }
                }
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            self.myLocation = location
            Utitlity.sharedInstance.user_current_location = location
            if(location.coordinate.latitude != 0){
                locationManager.stopUpdatingLocation()
            }
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 11, bearing: 0, viewingAngle: 0)
            
            mapView.isMyLocationEnabled = true
            //Load Events from server against user location
            if didFindLocation == false {
                didFindLocation = true
                
                if UserDefaults.standard.bool(forKey: "isUserLoging") == false {
                 //   getAllPublicEventFromServer()
                }else{
                    self.getPublicEventsFromServer()
                }
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController : GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let event_Id: String = marker.userData as! String
        
        print("You tapped \(marker.title ?? ""), \n at \(marker.position.latitude), \(marker.position.latitude)")
        
        print("Event ID: \(event_Id)")
        
        let eventDetailViewController: UINavigationController = Utitlity.getEventDetailViewController(WithEventID: String(event_Id))
        
        let navigationVC: UINavigationController = appDelegate.window?.rootViewController as! UINavigationController
        
        navigationVC.present(eventDetailViewController, animated: true, completion: nil)
        
        return true;
    }
    
    
    
    
    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        
//        let infoView = UIView()
//        infoView.frame = CGRect(x: 0, y: 0, width: 90, height: 90) //CGRectMake(0, 0, 90, 90);
//        // Setting the bg as red just to illustrate
//        infoView.backgroundColor = constants.getThemeTextColor()
//        return infoView;
//    }
    
}



extension MapViewController : GMSAutocompleteViewControllerDelegate, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.searchDisplayController?.searchBar.setNewcolor(UIColor.white)
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
        txt_search.text = place.formattedAddress
         mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
