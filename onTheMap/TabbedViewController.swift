//
//  TabbedViewController.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit

class TabbedViewController: UITabBarController {
    
    var locations: [StudentLocation] = [StudentLocation]() // prepare its type as struct -> prepares it to received the value from "getStudentLocations(C.H. returns: studentlocation, error)"
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        
        // save unqiue key to [LoginUser]
        
        
        
        // create and disable outlet "logout button"
        
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
        
        self.dismiss(animated: true, completion: nil)
    } // end of logoutBtnPressed
    
    // add "refresh" button action
    @IBAction func refreshBtnPressed(_ sender: AnyObject) {
        // call GET request of Student Locationssss
        UdacityClient.sharedInstance().getStudentsLocations { (studentsLocations, error) in
            if let locations = studentsLocations {
                self.locations = locations
                print("self.location inside refreshbtn is... \(self.locations.count)") // #100 right!
                performUIUpdatesOnMain {
                    // reload data ... but i dont have access to the tablview / mapview...
                    let StudentTable = self.viewControllers?[1] as? StudentsTableViewController
                    StudentTable?.locations = self.locations  // must have this to pass locations to next VC
                    StudentTable?.tableView.reloadData() // how to access viewcontroller of type of another view controller
                    
//                    let StudentMap = self.viewControllers?[0] as?
                         
                }
            } else {
                print(error)
            }
        }
    } // end of refreshBtnPressed
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // need to pass this studentInformation to Map and list (table view controller) file... so i can display them there
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillappear is called")
        UdacityClient.sharedInstance().getStudentsLocations { (studentsLocations, error) in
            if let locations = studentsLocations {
                self.locations = locations   // many struct of [StudentLocation]
                print("self.location count viewWillAppear is... \(self.locations.count)") // #100 right??
                performUIUpdatesOnMain {
                    let StudentTable = self.viewControllers?[1] as? StudentsTableViewController
                    StudentTable?.locations = self.locations // neccessary -> to pass locations to next VC
                    StudentTable?.tableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    } // closing viewWillAppear
} // end of class TabbedViewController

