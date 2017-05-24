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
        // then I don't need to keep "uninstall" The location view, to work on media view
        mediaDebug.lineBreakMode = NSLineBreakMode.byWordWrapping
        mediaDebug.numberOfLines = 4
        
        locationPostingStackView.isHidden = false
        mediaURLPostingStackView.isHidden = true
//        UdacityClient.sharedInstance().firstName = "testing111"
        
    } // end of viewDidLoad()
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func submitMediaURL(_ sender: Any) {
        let link = mediaURL.text! as String
       // disable button
        
        if (link.isEmpty) {
            self.displayError("Media URL cannot be blank")
            // enable button AGAIN
            return
        } else if !(link.hasPrefix("http://") || link.hasPrefix("https://"))  {
            self.displayError("Please add prefix - 'http:// or https://'")
            // enable button AGAIN
            return
        } else {
            
        // check if mediaURL is valid first ... - aborted as iOS9 requires to pre-register links app is going to list, limit - 50...
           
            UdacityClient.sharedInstance().mediaURL = link
            
            // hard code userID (=unique key) for now..
            UdacityClient.sharedInstance().submitStudentLoc() {(success, error) in  // will do all of below
            // should pass error back to here.... - have error -> alert view controller, no error, dismiss info view controller
                
                /* inside func submitStudentLoc - has listener for when "state" == "put", pop alertVC for overwrite
                 overwrite - 2 actions - 1. yes -> then call UdacityClient.shareInstance().putastudentlocation , 2. */
                
                print("error and success is \(error) \(success) INSIDE UdacityClient.sharedInstance().submitStudentLoc() ")
                
                guard (error == nil) else {  // have error
                    print("getAstudent failed, should show Alert box")
                    
                    let failedAddStudentAlert = UIAlertController(title: "Failure", message: error, preferredStyle: UIAlertControllerStyle.alert)
                    failedAddStudentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        failedAddStudentAlert.dismiss(animated: true, completion: nil)
                        
                        self.dismiss(animated: true, completion: nil) // go back to mapVC/ StudentsTVC 
                        // alert box -> "ok" (background still InfoPostingVC)-> then dismiss VC back to map view... - i want
                    }))
                    
                    performUIUpdatesOnMain {
                        self.present(failedAddStudentAlert, animated: true, completion: nil)
                    }
//                     self.dismiss(animated: true, completion: nil) // go back to mapVC/ StudentsTVC
//                     alert box appears + dismiss VC back to map view at the same time. background becomes map vc already

                    return // return is for guard () else
                } // End of if error != nil
                
                
                if success {
                    let addStudentAlert = UIAlertController(title: "Success", message: "Your Info are successfully added", preferredStyle: UIAlertControllerStyle.alert)
                    addStudentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        addStudentAlert.dismiss(animated: true, completion: nil) // dismiss Alert - when user clicks OK
                    }))
                    
                    performUIUpdatesOnMain {
                        self.present(addStudentAlert, animated: true, completion: nil)
                    }
                    self.dismiss(animated: true, completion: nil) // go back to mapVC/ StudentsTVC
                } // END of if success
                
            } // END of UdacityClient.sharedInstance().submitStudentLoc()
            // call several calls @ below submitStudentLoc()
            // 1. get a student location
            // 2. if nil call 2. POST a student location
            // 3. if != nil, 3. PUT a student location
            // 4. reloaddata...
            
            /* below to check if an URL is valid beforehand but iOS8 requires to preregister all URL, so I am not applying this block to my project
              if let checkedMediaURL = URL(string: link) {
                  let app = UIApplication.shared
                  let canOpen =  app.canOpenURL(checkedMediaURL)
                  if canOpen {
                      print("mediaURL can be opened", canOpen )  // www.ibifu.com can't be opened
                  } else {
                      print("mediaURL cannot be opened", canOpen )  // www.udacity.com can't be opened
                  }
                    result - canOpen - always FALSE as we didn't pre-register it!          
              } // end of "if let checkedMediaURL"  */
        } // end of else
        
    } // end of @IBAction func submitMediaURL
    
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil) // go back to mapVC/ StudentsTVC
    }
    
    @IBAction func findOnMapBtnPressed(_ sender: Any) {
        // once it's pressed, UI configure
        
        
        // geocode location string -> latitude + longtitude -> pass as var to sharedInstance().var - > MKMapView @ POST url view can retrieve it -> at that view, u add Mapview there.
        if locationInput.text!.isEmpty {
            self.displayError("Location cannot be blank") // InfoPostingVC stays...
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
                print("UdacityClient.sharedInstance().forwardGeocoding(location) runs")
                
                // stop activity indicator here 
                
                if error != nil { // error is an NSerror, displayError expects String....
                    print(error)
//                    self.debugArea.text = error
                    // call displayError() -> which shows alert window
                    self.displayError(error?.localizedDescription) // convert NSError to String with ".localizedDescription"
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
                    print("annotationList and coordinate returned from .placeAnnotation() is \(annotationList) \(coordinate)")
                    // make map zoom to pin
                    let span = MKCoordinateSpanMake(0.5, 0.5) // original: 0.5
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    
                    // add annotation to map
                    self.mapView.addAnnotations(annotationList)
                    
                    print(UdacityClient.sharedInstance().latitude) // it should not == nil - otherwise, means delete previous entry.
                    
                    // adding fading to hide/ show Views
                    UIView.animate(withDuration: 1, delay: 0.01, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        // show/ hide
                        self.locationPostingStackView.alpha = 0.0
                        self.mediaURLPostingStackView.isHidden = false
                    }, completion: nil)
                    
                } // end of else - when is location string is valid
            } // end of { (placemarks, error)
        } // end of else block
    } // end of  @IBAction func findOnMapBtnPressed
} // end of class

// MARK: - InformationPostingViewController - Configure UI
private extension InformationPostingViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        // disable button "submit" and what else ??
        
        if enabled {
            // button.alpha = 1.0
        } else {
            // button.alpha = 0.5
        }
        
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            
            // set UI alertVC
            let errorAlert = UIAlertController(title: "Failure", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                // what happens after "OK" is pressed? - dismiss the alertbox - back to original login page
                errorAlert.dismiss(animated: true, completion: nil)
            }))
            
            // need to call alert to present
            performUIUpdatesOnMain {
                self.present(errorAlert, animated: true, completion: nil) // have to place any interface code on mainQueue
            }
        }
    } // End of func displayError()
}

// no need for below - because both views share the SAME view controller....
//  when data is passed, bring to next controller.
// let controller = self.storyboard!.instantiateViewController(withIdentifier: "MediaPostingViewController")
// self.present(controller, animated: true, completion: nil)












