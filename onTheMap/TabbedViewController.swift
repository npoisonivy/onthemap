//
//  TabbedViewController.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit
import MapKit

class TabbedViewController: UITabBarController {
    @IBOutlet weak var logOutBtn: UIBarButtonItem!
    
    var locations: [StudentLocation] = [StudentLocation]() // prepare its type as struct -> prepares it to received the value from "getStudentLocations(C.H. returns: studentlocation, error)"
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        
        // create and disable outlet "logout button"
        logOutBtn.isEnabled = false
        
        // pop up alert - Are you sure to logout?
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        logOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            // call deleteSession!
            self.deleteSession()
            self.dismiss(animated: true, completion: nil)  // dismiss tabbedVC back to login page
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.logOutBtn.isEnabled = true
            self.dismiss(animated: true, completion: nil)  // dismiss alertbox
        }))

        self.present(logOutAlert, animated: true, completion: nil)
        // do i need to reset all logged user info?? - erase when login page is loaded before new user entered their credentials
        
    } // end of logoutBtnPressed
    
    // add "refresh" button action
    @IBAction func refreshBtnPressed(_ sender: AnyObject) {
        // call GET request of Student Locationssss - recall the getStudentsLocation - assign new locatiosn in the list
        UdacityClient.sharedInstance().getStudentsLocations { (studentsLocations, error) in
            if let locations = studentsLocations {
                self.locations = locations
                print("self.location inside refreshbtn is... \(self.locations.count)") // #100 right!
                performUIUpdatesOnMain {
                    // pass locations , reloaddata @ tableviewcontroller
                    // reload data ... but i dont have access to the tablview / mapview...
                    let StudentTable = self.viewControllers?[1] as? StudentsTableViewController
                    StudentTable?.locations = self.locations  // must have this to pass locations to next VC
                    print("StudentTable?.locations\(StudentTable?.locations)")
                    StudentTable?.tableView.reloadData() // reloaddata when refreshbutton is clicked
                    
                    // pass locations , reloaddata @ mapviewcontroller
                    let StudentMap = self.viewControllers?[0] as? MapViewController
                    StudentMap?.locations = self.locations
                    print("StudentMap?.locations - \(StudentMap?.locations)")
              
                    
                    // remove annotation - testing 1 - when refreshing - pin are gone BUT never get back
//                    let allAnnotations = StudentMap?.mapView.annotations
//                    StudentMap?.mapView.removeAnnotations(allAnnotations!)
                    
                    // call func displayAnnotation written @ mapViewController.
                    
                }
            } else {
                print(error)
            }
        }
    } // end of refreshBtnPressed
    
    // deleteSession when logout is confirmed
    func deleteSession() -> Void {
        // call Deleting session + go back to loginViewController
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            print("Logout is pressed, results as below")
            // do it right with "Encoding.utf8.rawValue" since call is to udacity.com
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    } // END of deleteSession()

    // Construct AnnotationsList
    func buildAnnotationsList() -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]() // set an empty array that belongs to MKPointAnnotation class
        
        // The MKPointAnnotation class defines a concrete annotation object located at a specified point
        // i can set properties to the annotation by- var coordinate: CLLocationCoordinate2D { lat, long set }
        
        // Version 1 - HARDCODE locations data
        // let locations = hardCodedLocationData()   // [[String : AnyObject]]
        // print("locations from hardCodedLocationData() is \(locations)")
        
        // Version 2 - locations is sent from TabbedViewController to MapViewController
        for dictionary in locations {
//            print("Now, looping through each locations")
            // going through the dictionary "locations", assign properties of each location to properties of the annotation (=the pin on the map view) = create a MKPointAnnotation for each location
            
            // when v1 use hardcoded locations - let locations = hardCodedLocationData() -> [[String : AnyObject]], use below to call "key" "latitude"
            // CCLocationCoordinate2D only takes long+lat in type "CCLocationDegress" - convert!
            // let lat = CLLocationDegrees(dictionary["latitude"] as! Double) - call latitude with "dictionary["latitude"]"
            
            // Now, v2, we use locations returned from TabbedVC's getStudentLocations() - datastructure:
            // ([onTheMap.StudentLocation(firstName: "Michael", lastName: "Stram", latitude: 41.883229, longitude: 0.0, mapString: "Chicago", ..), onTheMap.StudentLocation(firstName: "Ryan", lastName: "Phan", latitude: 37.338208199999997, longitude: -121.8863286, mapString: "San Jose, CA")
            
//             testing only
             print("lets check out location")
            print(dictionary.latitude)
            print(dictionary.longitude)
            
            
            // CCLocationCoordinate2D only takes long+lat in type "CCLocationDegress" - convert!
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // properties here - then assign first to annotation (the pin on mapview)
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            print("mediaURL inside for dictionary in locations is.. \(mediaURL)") // NOTHING!
            
            // Assign above properties of EACH location to EACH annotation (the pin on mapview) - to DISPLAY on mapview -
            // coordinate (extra), title, subtitle -> these 2 are similar to the "cell view" before.. the view always these as placeholder
            let annotation = MKPointAnnotation()   // as array [annotations] only holds MKPointAnnotation OBJECTS -> so here, we create an object that is type MKPointAnnotation() -> that is annotation.
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // We place the annotation in an array of annotation first before commanding the view to display
            
            annotations.append(annotation)  // annotations = [annotation1, annotation2, annotation3, ...]
        } // END of "for dictionary in locations"
        print("annotations array inside buildAnnotationArray is ", annotations) // RETURNED - have stuff in it.
        return annotations
    } // END of func buildAnnotationsList()

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****TabbedVC's viewWillAppear is called ")
    } // end of viewWillAppear
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("TabbedVC's viewDidLoad is called")
//    }
//
    // need to pass this studentInformation to Map and list (table view controller) file... so i can display them there
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabbedVC's viewDidLoad is called ")
        print("TabbedVC's viewDidLoad (temporarily replacing viewWillAppear is called")
        
//        print("viewWillappear @ TabbedViewController is called")
        
        UdacityClient.sharedInstance().getStudentsLocations { (studentsLocations, error) in
            if let locations = studentsLocations {
                self.locations = locations   // many struct of [StudentLocation]
                print("self.location count viewWillAppear is... \(self.locations.count)") // #100 right??
                performUIUpdatesOnMain {
                    // pass locations , reloaddata @ tableviewcontroller
                    let StudentTable = self.viewControllers?[1] as? StudentsTableViewController
                    
                    StudentTable?.locations = self.locations // neccessary -> to pass locations to next VC
                    print("now, passing locations from TabbedVC to TableViewController data: ", StudentTable?.locations )
                    
                    // let's comment it out and only call this when refreshbutton is clicked!
                     StudentTable?.tableView.reloadData() // it wouldn't work as viewDidLoad only run once, if u post a new student, dismiss infoPostingVC, and show tableview again, it won't "reloadData"
                    
                    // pass locations , reloaddata @ mapviewcontroller
                    let StudentMap = self.viewControllers?[0] as? MapViewController
                    print("now, passing locations from TabbedVC to MapViewController")
//                    StudentMap?.locations = self.locations // neccessary -> to pass locations to next VC
                    
                    // all these runs!!!
                    let testing = self.buildAnnotationsList()
                    print("testing is, ", testing )
                    StudentMap?.returnedAnnotations = self.buildAnnotationsList()  // return annotations [MKPointAnnotation]
                    print("StudentMap?.returnedAnnotations is", StudentMap?.returnedAnnotations)
                  
                    // call func displayAnnotation written @ mapViewController.
                    // i should INSTEAD dealt with locations HERE
                    // and return "builtAnnotations" and pass it to StudentMap
                    // like this - StudentMap?.builtAnnotations
                }
            } else {
                print(error)
            }
        }
    } // closing viewWillAppear
} // end of class TabbedViewController

