//
//  MapLocationViewController.swift
//  CatchUp
//
//  Created by aplome on 31/05/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


protocol MapLocationViewControllerDelegate {
    
    func selected(location: NearestLocation)
}


class MapLocationViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate, GMSAutocompleteViewControllerDelegate  {

    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var latlngTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var placeHolderLabel: UILabel!
    @IBOutlet var latiStringLabel: UILabel!
    @IBOutlet var longiStringLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var adressTextView: UITextView!
    @IBOutlet var latlngOverlayView: UIView!
    
    
    var delegate: MapLocationViewControllerDelegate!
    var selectedLocation : NearestLocation?
    
    var locationManager = CLLocationManager()
    var myLocation = CLLocation()
    let locationsArray : NSMutableArray = []
    var searchQuestionJustAsked : Bool = false
    
    
    //https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(MapLocationViewController.didDoneButtonPressed(_:))) //UIBarButtonItem.backButton(#imageLiteral(resourceName: "location-icon"), target: self, action: #selector(MapLocationViewController.didDoneButtonPressed(_:)))
        
 //       self.latlngTopConstraint.constant = 0
        
        self.mapView.delegate = self
        
      //  self.latlngOverlayView.layer.cornerRadius = 4.0
        
        self.adressTextView.layer.cornerRadius = 4.0
        self.adressTextView.layer.borderWidth = 1.0
        self.adressTextView.layer.borderColor = UIColor.gray.cgColor
        self.adressTextView.delegate = self
    
        self.updateLocation()
        self.longitudeLabel.isHidden = true
        
//        NotificationCenter.default.addObserver(self, selector: #selector(willKeyboardShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardHide(_:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(willKeyboardHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
      //  self.placeHolderLabel.isHidden = false
      //  latitudeLabel.text = "OR Tap on the Map to get the Address"
      //  latitudeLabel.isHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Keyboard Notifications
    
    func willKeyboardShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print("Height: \(keyboardHeight)")
            
            UIView.animate(withDuration: 0.2, animations: {
            
                self.view.setNeedsDisplay()
            })
        }
    }
    
    func didKeyboardShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print("Height: \(keyboardHeight)")
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.setNeedsDisplay()
            })
        }
    }
    
    func willKeyboardHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.setNeedsDisplay()
        })
    }
    
    func didKeyboardHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.setNeedsDisplay()
        })
    }
    
    // MARK: - Helper Methods
    
    func getAddress(fromLocation coordinate: CLLocationCoordinate2D) {
    
        Utitlity.sharedInstance.user_selected_location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        
        let geoCoder: CLGeocoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(Utitlity.sharedInstance.user_selected_location) { (markerArray, error) in
            
            if markerArray != nil {
            
                if (markerArray?.count)! > 0 {
                    
                    self.processResponse(withPlacemarks: markerArray, error: error)
                    
                    self.changeState(self.adressTextView)
                }
            }
        }
        
        Utitlity.sharedInstance.showProgressHud()
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            adressTextView.text = "Unable to Find Address for Location"
            
        } else {
            
            if (placemarks?.count)! > 0 {
            
                if let placemarks = placemarks, let placemark = placemarks.first {
                    
                    print(placemark)
                    
                    latitudeLabel.text = placemark.location?.coordinate.latitude.toString() //String(format: "%.6f", (placemark.location?.coordinate.latitude)!)
                    longitudeLabel.text = placemark.location?.coordinate.longitude.toString() //String(format: "%.6f", (placemark.location?.coordinate.longitude)!)
                    adressTextView.text = placemark.compactAddress
                    
                    self.selectedLocation = NearestLocation()
                    
                    self.selectedLocation?.loc_lat = latitudeLabel.text
                    self.selectedLocation?.loc_long = longitudeLabel.text
                    self.selectedLocation?.loc_Name = placemark.name
                    self.selectedLocation?.loc_address = adressTextView.text
                    
                } else {
                    adressTextView.text = "No Matching Addresses Found"
                }
            }
        }
        
        Utitlity.sharedInstance.hideProgressHud()
    }
    
    func updateLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func getLocation(withPlaceId placeId: String, location: CLLocationCoordinate2D, name: String) {
    
        let str_url = String(format: "https://maps.googleapis.com/maps/api/geocode/json?place_id=%@&key=%@",placeId,constants.kAPIKey)
        
        NetworkServices.sharedInstance.getWebServiceWith(str_url, params: [:]) { (success, responseDict) in
            if success {
                let results_Array = responseDict["results"] as! NSArray
                
                for result_dict in results_Array as! [NSDictionary] {
                    
                    let locationAddress = result_dict["formatted_address"] as! String
                    
                    let geometry: [String: Any] = result_dict["geometry"] as! [String: Any]
                    
                    let locationStr: [String: Any] = geometry["location"] as! [String: Any]
                    
                    let lat: String = (locationStr["lat"] as! Double).toString()
                    let lng: String = (locationStr["lng"] as! Double).toString()
                    
                    self.latitudeLabel.text = lat//String(location.latitude) //String(format: "%lu", (location.latitude))
                    self.longitudeLabel.text = lng //String(format: "%lu", (location.longitude))
                    
                    self.adressTextView.text = "\(name), \(locationAddress)"
                        
                    self.selectedLocation = NearestLocation()
                    
                    self.selectedLocation?.loc_lat = self.latitudeLabel.text
                    self.selectedLocation?.loc_long = self.longitudeLabel.text
                    self.selectedLocation?.loc_Name = name
                    self.selectedLocation?.loc_address = self.adressTextView.text
                    self.longitudeLabel.isHidden = true
                }
                
                self.changeState(self.adressTextView)
                
            }
            Utitlity.sharedInstance.hideProgressHud()
        
        }
    }
    
    func getNearestLocations(placeId: String = "") {
        Utitlity.sharedInstance.showProgressHud()
        //        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDKvD9019JdUOR8RGrBvzuIfldeGm8vKmQ&location=31.56685,74.54686&radius=10000&type=restaurant,movie_theater&rankby=prominence&sensor=true"
        
        
        
        let strlatLong = "\(Utitlity.sharedInstance.user_selected_location.coordinate.latitude)"+","+"\(Utitlity.sharedInstance.user_selected_location.coordinate.longitude)"
        
//        let str_url = String(format: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@&location=%@&radius=10000&type=restaurant,movie_theater&rankby=prominence&sensor=true",constants.kAPIKey,strlatLong)
        
        let str_url1 = String(format: "https://maps.googleapis.com/maps/api/geocode/json?place_id=%@&key=%@",placeId,constants.kAPIKey)

        
//        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(strlatLong)&key=\(constants.kAPIKey)&language=en&result_type=country"
        
        if self.locationsArray.count > 0 {
            
            self.locationsArray.removeAllObjects()
        }
        
        NetworkServices.sharedInstance.getWebServiceWith(str_url1, params: [:]) { (success, responseDict) in
            if success {
                let results_Array = responseDict["results"] as! NSArray
                
                
//                if results_Array.count > 0 {
//                    for result_dict in results_Array as! [NSDictionary] {
//                        
//                        let geomateryDict = result_dict["geometry"] as! NSDictionary
//                        let locationDict  = geomateryDict["location"] as! NSDictionary
//                        let locationName = result_dict["name"] as! String
//                        let locationAddress = result_dict["vicinity"] as! String
//                        var locationRating = ""
//                        if result_dict.object(forKey: "rating") != nil {
//                            locationRating  = String(describing: result_dict["rating"]!)
//                        }
//                        
//                        let location = NearestLocation()
//                        location.loc_Name = locationName
//                        location.loc_address = locationAddress
//                        location.loc_rate    = locationRating
//                        location.loc_img_url = ""
//                        
//                        if result_dict.object(forKey: "icon") != nil {
//                        
//                            location.loc_img_url = result_dict["icon"] as! String
//                        }
//                        
//                        location.loc_lat     = String(describing: locationDict["lat"]!)
//                        location.loc_long     = String(describing: locationDict["lng"]!)
//                        
//                        self.locationsArray.add(location)
//                    }
////                   
//                    
//                }
            }
            Utitlity.sharedInstance.hideProgressHud()
            
//            self.performSegue(withIdentifier: "LocationListSegue", sender: nil);
        }
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func didDownButtonPressed(_ sender: UIButton) {
        
        self.adressTextView.resignFirstResponder()
    }

    @IBAction func cancelAddressPressed(_ sender: UIButton) {
        
        self.selectedLocation = nil
        self.adressTextView.text = ""
      //  self.navigationController?.popViewController(animated: true)
       // self.adressTextView.resignFirstResponder()
    }

    
    func didDoneButtonPressed(_ sender: UIButton) {
    
        if self.adressTextView.text != "" || self.selectedLocation != nil {
            
            if let delegate = self.delegate {
                
                self.selectedLocation?.loc_address = adressTextView.text
                delegate.selected(location: self.selectedLocation!);
            }
            
            self.navigationController?.popViewController(animated: true)
            //        self.dismiss(animated: true, completion: nil)
        }
        else {
        
            Utitlity.sharedInstance.showAlert(self, message: "Please select a location from the map or search using the text field")
        }
    }
    
    func changeState(_ textView: UITextView) {
        
        if textView.text == "" {
            
            self.placeHolderLabel.isHidden = true
            
            UIView.animate(withDuration: 0.2, animations: {
              
//                self.latlngTopConstraint.constant = 0
                self.view.setNeedsDisplay()
            })
        }
        else {
            
            self.placeHolderLabel.isHidden = true
            
            UIView.animate(withDuration: 0.2, animations: {
                
//                self.latlngTopConstraint.constant = 0
                self.view.setNeedsDisplay()
            })
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.changeState(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        if((self.selectedLocation) == nil){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.searchDisplayController?.searchBar.setNewcolor(UIColor.white)
        self.present(autocompleteController, animated: true, completion: nil)
        }

        
//        if(!searchQuestionJustAsked){
//        let alert  = UIAlertController.init(title: "Google Search", message: "Do you want to search the location on maps ?", preferredStyle: UIAlertControllerStyle.alert)
//        
//        let defaultAction = UIAlertAction(title: "NO", style: .cancel) { (alertAction) in
//            
//            self.searchQuestionJustAsked = false
//        }
//        
//        let yesAction = UIAlertAction(title: "YES", style: .default) { (alertAction) in
//            
//
//            self.searchQuestionJustAsked = false
//        }
//
//        
//        alert.addAction(defaultAction)
//        alert.addAction(yesAction)
//        
//        self.present(alert, animated: true, completion: nil)
//
//        self.searchQuestionJustAsked = true
      //  }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.changeState(textView)
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.changeState(textView)
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            self.myLocation = location
            Utitlity.sharedInstance.user_current_location = location
            locationManager.stopUpdatingLocation()
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            
            mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     
        print(error)
    }
    
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MapLocationViewController: GMSMapViewDelegate {

    // Mark: - GMSMapViewDelegate
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.getAddress(fromLocation: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {

        self.getLocation(withPlaceId: placeID, location: location, name: name)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        latitudeLabel.text = place.coordinate.latitude.toString() //String(format: "%.6f", (placemark.location?.coordinate.latitude)!)
        longitudeLabel.text = place.coordinate.longitude.toString() //String(format: "%.6f", (placemark.location?.coordinate.longitude)!)

        self.adressTextView.text = place.formattedAddress
        mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        self.selectedLocation = NearestLocation()
        self.selectedLocation?.loc_lat = latitudeLabel.text
        self.selectedLocation?.loc_long = longitudeLabel.text
        self.selectedLocation?.loc_Name = place.name
        self.selectedLocation?.loc_address = adressTextView.text

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
