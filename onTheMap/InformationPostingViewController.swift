//
//  InformationPostingViewController.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate {
    // for google map api
//    let baseURL = "https://maps.googleapis.com/maps/api/geocode/json?"
//    let apikey = "AIzaSyD9Jjbs5ZOW05aS2ZYF8j_EV_NCbRXPwKk"

    @IBOutlet weak var locationPostingStackView: UIStackView!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var debugArea: UILabel!
    
    @IBOutlet weak var mediaURLPostingStackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaURL: UITextField!
    
    @IBOutlet weak var mediaDebug: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugArea.text = ""
        mediaDebug.text = ""
        locationPostingStackView.isHidden = false
        mediaURLPostingStackView.isHidden = true
        UdacityClient.sharedInstance().firstName = "testing111"
        
    } // end of viewDidLoad()
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func submitMediaURL(_ sender: Any) {
        if (mediaURL.text?.isEmpty)! {
            mediaDebug.text = "Media URL cannot be blank"
            return
        } else {
            // check if mediaURL is valid first ...
            let mediaURL = self.mediaURL.text!.removingPercentEncoding!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
            if let checkedMediaURL = NSURL(string: mediaURL) {
                print("printing mediaURL")
                print(self.mediaURL.text!)
                print(mediaURL)
                print(checkedMediaURL)
                
//                UdacityClient.sharedInstance().mediaURL = mediaURL.text
                
                // call several calls @ below submitStudentLoc()
                // 1. get a student location
                // 2. if nil call 2. POST a student location
                // 3. if != nil, 3. PUT a student location
                // 4. reloaddata...
                
                // hard code userID (=unique key) for now..
                UdacityClient.sharedInstance().submitStudentLoc() // will do all of above
                
            } // end of "if let checkedMediaURL"
        } // end of else
    } // end of @IBAction func submitMediaURL
    
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil) // go back to mapVC/ StudentsTVC
    }
    
    @IBAction func findOnMapBtnPressed(_ sender: Any) {
        // geocode location string -> latitude + longtitude -> pass as var to sharedInstance().var - > MKMapView @ POST url view can retrieve it -> at that view, u add Mapview there.
        if locationInput.text!.isEmpty {
            debugArea.text = "Location cannot be blank"
            // view stays...
            return
        } else { // have something...
            let location = locationInput.text! as String
            // do i need to store location to sharedInstance().location/?
            UdacityClient.sharedInstance().location = location
            
            print("location is \(location)")
            
            // Google :
//            let baseURL = "https://maps.googleapis.com/maps/api/geocode/json?"
//            let apikey = "AIzaSyD9Jjbs5ZOW05aS2ZYF8j_EV_NCbRXPwKk"
            
            // apple - call forwardGeocoding() - return lat/ long, and we save it, then mkmapview will be using it to show location pin annotation.
            // GeoCoding
            UdacityClient.sharedInstance().forwardGeocoding(location) { (latitude, longitude, error) in
                 // sharedInstance() -> create a Udacity class -> func forwardGeocoding is under that class.
                // placemarks as AnyObject , error returned
                print("UdacityClient.sharedInstance().forwardGeocoding(location) even runs??")
                if error != nil {
                    print(error)
//                    self.debugArea.text = error
                    return
                } else {  // no error
                    print("saving latitude, longitude as UdacityClient.sharedInstance()") // runs
                   // save latitude/ longitude to sharedinstance()
                    UdacityClient.sharedInstance().latitude = latitude  //- it;s not populating the variable auto - just hardcode
                    UdacityClient.sharedInstance().longitude = longitude
                    print("latitude is \(UdacityClient.sharedInstance().latitude) and longitude is \(UdacityClient.sharedInstance().longitude)") // runs
                    
                    print("check if firstname is replace by calling func geocoding \( UdacityClient.sharedInstance().firstName)")  // would not get replaced :) good!
                    
                    // set pin to annotation - on the mapView : show annotation!
                    let (annotationList, coordinate) = UdacityClient.sharedInstance().placeAnnotation()
               
                    // make map zoom to pin
                    let span = MKCoordinateSpanMake(0.5, 0.5)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    
                    // add annotation to map
                    self.mapView.addAnnotations(annotationList)
                    
                    print(UdacityClient.sharedInstance().latitude) // it should not == nil - otherwise, means delete previous entry.
                    
                    // adding fading to hide/ show Views
                    UIView.animate(withDuration: 3, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        // show/ hide
                        self.locationPostingStackView.alpha = 0.0
                        self.mediaURLPostingStackView.isHidden = false
                    }, completion: nil)
                    
                } // end of else - when is location string is valid
            } // end of { (placemarks, error)
        } // end of else block
    } // end of  @IBAction func findOnMapBtnPressed
    
    
    
    
    
    

} // end of class


// no need for below - because both views share the SAME view controller....
//  when data is passed, bring to next controller.
// let controller = self.storyboard!.instantiateViewController(withIdentifier: "MediaPostingViewController")
// self.present(controller, animated: true, completion: nil)
