//
//  MapViewController.swift
//  onTheMap
//
//  Created by Nikki L on 3/4/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit
import MapKit

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // add the properties in struct studentlocation - to expect what will be passed to here. 
    var locations: [StudentLocation] = [StudentLocation]()
    var returnedAnnotations: [MKPointAnnotation] = [MKPointAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MapVC's viewWillAppear is called")
        print("@viewWillAppear, data being passed from TabbedVC to MapViewController are \(self.locations)")
//        let locations = self.locations
//        print("returnedAnnotations inside mapView is", returnedAnnotations) // [] - nothing
        // remove annotation - testing 2
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        self.mapView.addAnnotations(returnedAnnotations)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapVC's viewDidLoad is called")
        // replace hardCodedLocationData() with -> "self.location" passed from tabbedViewController
        // let locations = self.locations - no need because global "locations" was set at the beginning!
        print("locations got passed over from tabbedVC to MapViewCcontroller is \(locations), right before for loop") // [] -> nothing!!
        
        
//        let builtAnnotations = buildAnnotationsList()  // builtAnnotations = [annotation1, annotation2, ...]
        
        // update the outlet "mapView" with annotatioons set above
        // original : self.mapView.addAnnotations(Annotations)
        print("returnedAnnotations is ", returnedAnnotations)
        
//        self.mapView.addAnnotations(returnedAnnotations) // it wouldn't work here ... as viewDidLoad only got called ONCE
       
    } // END of override func viewDidLoad()

    /* Since you are processing the data that is passed from tabbedViewController, instead of locally here "hardCodedData()". "hardCodedData()" - we put inside viewDidLoad VS "Location" INSIDE func similar to table - override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // CALL LOCATION DATA what was passed from another VC - TabbedVC */

    
// MARK: - MKMapViewDelegate - Calling its func here ...
// Like each row indexPath, add the next content. Similar here each spot, add the next annotation
    
// Here we create a view with a "right callout accessory view". You might choose to look into other decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath method in TableViewDataSource.
  
// Under MKMapViewDelegate - public protocol MKMapViewDelegate : NSObjectProtocol {
//  optional public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuserId = "pin"
        
        //    From MKMapViewDelegate - public protocol MKMapViewDelegate : NSObjectProtocol { it has:
        //  open func dequeueReusableAnnotationView(withIdentifier identifier: String) -> MKAnnotationView?
        // pinView here = cell in collection/ table view - to dequeueReusable views...
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId) as? MKPinAnnotationView
        // pinView is now one of the "MKPinAnnotationView" -> means it can call its properties as below:
        
        if pinView == nil {   // not sure what does this do - ask Mentor
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {    // dequeueReusable "Cell" = place pin of student on the map
            pinView!.annotation = annotation   // -> this is from dictionary part
        }
        
        return pinView
    }
    
    
    // Above, can already display student's location on map with pin. this following method is to allow mediaURL opens upon taps
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    // Under MKMapViewDelegate - public protocol MKMapViewDelegate : NSObjectProtocol { optional public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! { // if annotation has subtitle - = mediaURL
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    
    func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z" as AnyObject,
                "firstName" : "Jessica" as AnyObject,
                "lastName" : "Uelmen" as AnyObject,
                "latitude" : 28.1461248 as AnyObject,
                "longitude" : -82.75676799999999 as AnyObject,
                "mapString" : "Tarpon Springs, FL" as AnyObject,
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en" as AnyObject,
                "objectId" : "kj18GEaWD8" as AnyObject,
                "uniqueKey" : 872458750 as AnyObject,
                "updatedAt" : "2015-03-09T22:07:09.593Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z" as AnyObject,
                "firstName" : "Gabrielle" as AnyObject,
                "lastName" : "Miller-Messner" as AnyObject,
                "latitude" : 35.1740471 as AnyObject,
                "longitude" : -79.3922539 as AnyObject,
                "mapString" : "Southern Pines, NC" as AnyObject,
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en" as AnyObject,
                "objectId" : "8ZEuHF5uX8" as AnyObject,
                "uniqueKey" : 2256298598 as AnyObject,
                "updatedAt" : "2015-03-11T03:23:49.582Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z" as AnyObject,
                "firstName" : "Jason" as AnyObject,
                "lastName" : "Schatz" as AnyObject,
                "latitude" : 37.7617 as AnyObject,
                "longitude" : -122.4216 as AnyObject,
                "mapString" : "18th and Valencia, San Francisco, CA" as AnyObject,
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29" as AnyObject,
                "objectId" : "hiz0vOTmrL" as AnyObject,
                "uniqueKey" : 2362758535 as AnyObject,
                "updatedAt" : "2015-03-10T17:20:31.828Z" as AnyObject
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z" as AnyObject,
                "firstName" : "Jarrod" as AnyObject,
                "lastName" : "Parkes" as AnyObject,
                "latitude" : 34.73037 as AnyObject,
                "longitude" : -86.58611000000001 as AnyObject,
                "mapString" : "Huntsville, Alabama" as AnyObject,
                "mediaURL" : "https://linkedin.com/in/jarrodparkes" as AnyObject,
                "objectId" : "CDHfAy8sdp" as AnyObject,
                "uniqueKey" : 996618664 as AnyObject,
                "updatedAt" : "2015-03-13T03:37:58.389Z" as AnyObject
            ]
        ]
    }

}
