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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****TabbedVC's viewWillAppear is called ")
        // displayLocations()
        
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
        displayLocations()
        //        print("viewWillappear @ TabbedViewController is called")
        // displayLocations() - if calling it from viewWillAppear, no need to call it agin when viewVidLoad ...
    } // closing viewWillAppear
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        
        // create and disable outlet "logout button"
        logOutBtn.isEnabled = false
        
        // pop up alert - Are you sure to logout?
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        logOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            // call deleteSession!
            UdacityClient.sharedInstance().deleteASession()
            logOutAlert.dismiss(animated: true, completion: nil) // dismiss  Alert
            self.dismiss(animated: true, completion: nil)  // dismiss tabbedVC back to login page- but slow... - ASK mentor..
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.logOutBtn.isEnabled = true
            logOutAlert.dismiss(animated: true, completion: nil) // dismiss alertbox
        }))

        performUIUpdatesOnMain {
            self.present(logOutAlert, animated: true, completion: nil)
        }
    } // end of logoutBtnPressed
    
    // add "refresh" button action
    @IBAction func refreshBtnPressed(_ sender: AnyObject) {
        // call GET request of Student Locationssss - recall the getStudentsLocation - assign new locatiosn in the list
        displayLocations()
    } // end of refreshBtnPressed
} // end of class TabbedViewController

private extension TabbedViewController {
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            let errorAlert = UIAlertController(title: "Failure", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                errorAlert.dismiss(animated: true, completion: nil) // dismiss current alert VC from screen
            }))
            
            // call UI interface in main queue
            performUIUpdatesOnMain {
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    } // end of func displayError
    
    // Call getStudentsLocations(), display data on tableView/ mapView
    func displayLocations() -> Void {
        UdacityClient.sharedInstance().getStudentsLocations { (studentsLocations, error) in
            
            // handles error:
            guard (error == nil) else {
                // have error
                self.displayError(error?.localizedDescription)
                return
            }
            
            print("studentsLocations (inside displayLocation() - coming back from getStudentsLocations is...", studentsLocations)
            
            //StudentModel.sharedInstance().listofStudents = studentsLocations! // assign to listofStudents
            // locations and StudentModel.sharedInstance() shares same value "studentsLocations" returned from getStudentsLocations
            
            if let locations = studentsLocations {
                StudentModel.sharedInstance().listofStudents = studentsLocations!
                print("Got the locations from getStudentsLocation call")
                DispatchQueue.main.async {
                    // does not assign studentsLocations to locations unless locations != nil
                    // instead of doing this - save locations to singleton.sharedinstance.listofstudents
                    self.locations = locations // many struct of [StudentLocation]
                    
                    // now we have locations to pass to next controller....
                    
                    // supposed to call below - but we should call it from mapVC...
                    // self.mapView.addAnnotations(buildAnnotationsList())// returned datatype: [MKPointAnnotation] -
                    print("self.location count viewWillAppear is... \(self.locations.count)") // #100 right?? - self.location count viewWillAppear is... 50
                    performUIUpdatesOnMain {
                        
                        // reloaddata @ tableviewcontroller
                        let StudentTable = self.viewControllers?[1] as? StudentsTableViewController
                        
                        // no need to pass anymore - just access studentlocation with StudentModel.sharedInstance().listofStudents
                        // StudentTable?.locations = self.locations // neccessary -> to pass locations to next VC
                        // print("now, passing locations from TabbedVC to TableViewController data: ", StudentTable?.locations )
                        
                        // let's comment it out and only call this when refreshbutton is clicked!
                        StudentTable?.tableView.reloadData() // it wouldn't work as viewDidLoad only run once, if u post a new student, dismiss infoPostingVC, and show tableview again, it won't "reloadData"
                        
                        // reloaddata @ mapviewcontroller
                        // Map View
                        let StudentMap = self.viewControllers?[0] as? MapViewController
                        StudentMap?.buildAnnotationsList() // this func stored @ mapVC...
                        
                        
                        //StudentMap?.locations = self.locations // don't need this anymore as we access location with "StudentModel.sharedInstance().listofStudents"
                  
                        
                        // all these runs!!!
                        // let test_ob = self.buildAnnotationsList()
                        // print("testing is, ", test_ob )
                        
                        // call func displayAnnotation written @ mapViewController.
                        // i should INSTEAD dealt with locations HERE
                        // and return "builtAnnotations" and pass it to StudentMap
                        // like this - StudentMap?.builtAnnotations
                    } // END of performUIUpdatesOnMain

                } // End of DispatchQueue.main.async
            } /* end of "if studentsLocations != nil" */ else {
                print("No data of student locations come back!")
            }
        } // end of UdacityClient.sharedInstance().getStudentsLocations
    } // End of func displayLocations()
} // end of "private extension TabbedViewController {"

    
    



