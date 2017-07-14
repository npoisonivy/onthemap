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

    @IBOutlet weak var mapView: MKMapView! // it does not have MKMapViewDelegate till adding "self.mapView.delegate = self  // self = MapVC.swift"
    
    // var locations: [StudentLocation] = [StudentLocation]() // prepare its type as struct -> prepares it to received the value from "getStudentLocations(C.H. returns: studentlocation, error) from tabbedVC.swift"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MapVC's viewWillAppear is called")
        
        self.mapView.delegate = self  // self = MapVC.swift
        
        print("locations passed from tabbedVC @ viewWillAppear is..", StudentModel.sharedInstance().listofStudents)
        
        // remove all annotations before showing the new ones
        // below is called ONLY when Mapview icon is clicked --> but NOT when refresh is pressed!
        // print("showing all new locations on map")
        
        buildAnnotationsList()
        
        /*let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.addAnnotations(buildAnnotationsList())// returned datatype: [MKPointAnnotation]*/
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapVC's viewDidLoad is called")
        print("locations passed from tabbedVC @ viewDidLoad is..", StudentModel.sharedInstance().listofStudents)
        // replace hardCodedLocationData() with -> "self.location" passed from tabbedViewController
        // let locations = StudentModel.sharedInstance().listofStudents - no need because global "locations" was set at the beginning!
        // @ TabbedVC -> buildAnnotationsList() (below) is called, and it is passed to current MapVC
//        let builtAnnotations = buildAnnotationsList()  // builtAnnotations = [annotation1, annotation2, ...]
        
        // update the outlet "mapView" with annotations set above
        // original : self.mapView.addAnnotations(Annotations)
        
        self.mapView.delegate = self  // self = MapVC.swift
        
        print("buildAnnotationsList is ", buildAnnotationsList())
        
        
        
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

extension MapViewController {
    // Construct AnnotationsList
    func buildAnnotationsList() -> Void {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        var annotations = [MKPointAnnotation]() // set an empty array that belongs to MKPointAnnotation class
        
        // The MKPointAnnotation class defines a concrete annotation object located at a specified point
        // i can set properties to the annotation by- var coordinate: CLLocationCoordinate2D { lat, long set }
        
        // Version 1 - HARDCODE locations data
        // let locations = hardCodedLocationData()   // [[String : AnyObject]]
        // print("locations from hardCodedLocationData() is \(locations)")
        
        // Version 2 - locations is sent from TabbedViewController to MapViewController
        for dictionary in StudentModel.sharedInstance().listofStudents {
            //            print("Now, looping through each StudentModel.sharedInstance().listofStudents")
            // going through the dictionary "locations", assign properties of each location to properties of the annotation (=the pin on the map view) = create a MKPointAnnotation for each location
            
            // when v1 use hardcoded locations - let locations = hardCodedLocationData() -> [[String : AnyObject]], use below to call "key" "latitude"
            // CCLocationCoordinate2D only takes long+lat in type "CCLocationDegress" - convert!
            // let lat = CLLocationDegrees(dictionary["latitude"] as! Double) - call latitude with "dictionary["latitude"]"
            
            // Now, v2, we use locations returned from TabbedVC's getStudentLocations() - datastructure:
            // ([onTheMap.StudentLocation(firstName: "Michael", lastName: "Stram", latitude: 41.883229, longitude: 0.0, mapString: "Chicago", ..), onTheMap.StudentLocation(firstName: "Ryan", lastName: "Phan", latitude: 37.338208199999997, longitude: -121.8863286, mapString: "San Jose, CA")
            
            //             testing only
            //             print("lets check out location")
            //            print(dictionary.latitude)
            //            print(dictionary.longitude)
            
            
            // CCLocationCoordinate2D only takes long+lat in type "CCLocationDegress" - convert!
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // properties here - then assign first to annotation (the pin on mapview)
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            //            print("mediaURL inside for dictionary in locations is.. \(mediaURL)") // NOTHING!
            
            // Assign above properties of EACH location to EACH annotation (the pin on mapview) - to DISPLAY on mapview -
            // coordinate (extra), title, subtitle -> these 2 are similar to the "cell view" before.. the view always these as placeholder
            let annotation = MKPointAnnotation()   // as array [annotations] only holds MKPointAnnotation OBJECTS -> so here, we create an object that is type MKPointAnnotation() -> that is annotation.
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // We place the annotation in an array of annotation first before commanding the view to display
            
            annotations.append(annotation)  // annotations = [annotation1, annotation2, annotation3, ...]
        } // END of "for dictionary in locations"
        //        print("annotations array inside buildAnnotationArray is ", annotations) // RETURNED - have stuff in it.
        
        self.mapView.addAnnotations(annotations) // exactly the SAME as line 47 - so no need to repeat that!
        // return annotations // data type: [MKPointAnnotation] - don;t need this as we already have above command to put annotations on the map
    } // END of func buildAnnotationsList()


    
    
    
} // End of private extension MapViewController





























