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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // getStudentsLocations() from UdacityConvenience.swift where the whole file is an extension of UdacityClient - "extension UdacityClient"
//        UdacityClient.sharedInstance().getStudentsLocations { (namethisanything, error) in
//            if let locations = namethisanything {
//                self.locations = locations
//                performUIUpdatesOnMain {
////                    self.mapView.reloadData() // does not work...
//                    
//                }
//            }
//        }
        
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get Locations data
        let locations = hardCodedLocationData()   // [[String : AnyObject]]
        
        var annotations = [MKPointAnnotation]()
        // set an empty array that belongs to MKPointAnnotation class
        // The MKPointAnnotation class defines a concrete annotation object located at a specified point
        // i can set properties to the annotation by- var coordinate: CLLocationCoordinate2D { lat, long set } 
        
        
        // and display location data...
        // going through the dictionary "locations", assign properties of each location to properties of the annotation (=the pin on the map view) = create a MKPointAnnotation for each location
        for dictionary in locations {
            
            // CCLocationCoordinate2D only takes long+lat in type "CCLocationDegress" - convert!
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // properties here - then assign first to annotation (the pin on mapview)
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            
            // Assign above properties of EACH location to EACH annotation (the pin on mapview) - to DISPLAY on mapview - 
            // coordinate (extra), title, subtitle -> these 2 are similar to the "cell view" before.. the view always these as placeholder
            let annotation = MKPointAnnotation()   // as array [annotations] only holds MKPointAnnotation OBJECTS -> so here, we create an object that is type MKPointAnnotation() -> that is annotation.
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // We place the annotation in an array of annotation first before commanding the view to display
            annotations.append(annotation)
        }
        
        // update the outlet "mapView" with annotatioons set above
        self.mapView.addAnnotations(annotations)
       
    }

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
