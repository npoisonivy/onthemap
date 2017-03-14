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

            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // add "refresh" button action
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        // call GET request of Student Locationssss
        UdacityClient.sharedInstance().getStudentsLocations { (studentsLocations, error) in
            if let locations = studentsLocations {
                self.locations = locations
                performUIUpdatesOnMain {
                    // reload data ... but i dont have access to the tablview / mapview...
                }
            } else {
                print(error)
            }
    }
    
    
    func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    var students: [Students] = [Students]() // all students info got saved to this from the server
    
    // need to pass this studentInformation to Map and list (table view controller) file... so i can display them there
    

    
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UdacityClient.sharedInstance().getStudentsLocations { (namethisanything, error) in
            if let locations = namethisanything {
                self.locations = locations   // many struct of [StudentLocation]
            } else {
                print(error)
            }
        }
    }

    
        // when it returns, it will return "students"'s user id, fn, ln, media url to display...we can use below code
//        TMDBClient.sharedInstance().getFavoriteMovies { (movies, error) in
//            if let movies = movies {
//                self.movies = movies -> save movies/ students on this very tabbed view controller on top
//                performUIUpdatesOnMain {
//                    self.moviesTableView.reloadData()
//                }
//            } else {
//                print(error)
//            }
//        }

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     // send the above Students info to the next view controller.
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}

