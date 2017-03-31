//
//  UdacityConvenience.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import AddressBookUI
import MapKit

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    // MARK: Authentication (POST) Methods
    //authenticateWithViewController - takes a self viewController because -> in client's side - only one screen, but at the back, there were a lot of things happening - ex: request token, login with Token after token is obtained, etc... but this app is very simple, just need to get a session id in order to make any GET/ POST request
    
    /* Write 3 functions:
    1. authenticateWithViewController (call 2&3) 2. getUserID 3. getPublicData
    */
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        // success, errorString will be passed back to here from below
        
        // call .getPublicUserData below:
        getPublicUserData() { (success, firstName, lastName, errorString) in
            // result returns to here... - get firstname, and lastname, and saved to UdacityClient.sharedInstance().firstname
            print("data passed from .getPublicData - firstname is ... \(firstName) & lastname is ... \(lastName)")
            // we should store the data is success
            if success {  // no need to send success/ erro back to LoginVC as it does not affect user logging in..
                UdacityClient.sharedInstance().firstName = firstName
                UdacityClient.sharedInstance().lastName = lastName
            } else {
                print("User doesn't seem to have firstname/ lastname")
            }
            
        }
        
        
        
        
//        // Comment below all to now only test out. getPublicData() call, hardcoded user_id
//        // call 2. getUserID - check if it works...
//        print("username from textfield is \(username)") // check if I successfuly save/ retrieve username, then i can pass it to .getUserID(username, pw)
////        UdacityClient.sharedInstance().username - pass to UdacityClient already
//        getUserID(username!, password!) { (success, userID, errorString) in  // current page is extension of UdacityClient, so I can call its properties directly - errorString passed -"can't retrieve user id"
//            
//            print("username passed from LoginVC is \(self.username), password is \(self.password)")
//            
//            if success {
//                print("UserID is... \(userID)")
//                self.userID = userID  // self = current func authenticateWithViewController
//                
//                // do i need to pass completionHandlerForAuth(success, errorString)?
//                
//                
//                // pass userID to getPublicData... - add it after testing purely getUserID
//       
//            } else {
//                completionHandlerForAuth(success, errorString)  // pass "can't retrieve user id" from .getUserID
//            }
//        } // end of .getUserID
////
        
        
        // must pass the (completionHandlerForAuth: xxx, xxx) - so the LoginVC where .authenticateWithViewController is calling - can receive the returned "success/ errostring" - and upon those return, either completeLogin() or displayError will be called

        
    } // end of authenticateWithViewController
    
    func getUserID(_ username: String, _ password: String, _ completionHandlerForGETUserID: @ escaping (_ success: Bool, _ userID: String?, _ errorString: String?) -> Void) {

        // screen off the username/ password
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body since it's a POST - ONLY need: normal method: https://www.udacity.com/api/session;  no need to add any parameter k:v, no need for substituteKeyInMethod */
        let parameters = [String:AnyObject]()
 
        print("username being passed over is.. \(username)") // username being passed over is.. spacenikki@gmail.com
        
        self.baseURL = "udacity"  // change the self.baseURL that func "studentURLFromParameters" reads it and return the corresponding APIScheme, APIHost, APIPath
        let method: String = Methods.Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        print("jsonBody is ..\(jsonBody)") // jsonBody is ..{"udacity": {"username": "spacenikki@gmail.com", "password": "wifi=123"}} -> not matching what we wanted... 
    
        
        /* Original @ playground:
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8) */
        
        /* 2. Make the request - [pass everything from above to taskForPOSTMethod*/
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            print("POST Session's result of func getUserID ...\(results)")
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGETUserID(false, nil, "Login Failed (Can't retrieve User ID!).")
            } else {
                /* { "account":{ "registered":true, "key":"3903878747" }, "session":{ "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088", "expiration":"2015-05-10T16:48:30.760460Z" } } */
                if let result = results?[JSONResponseKeys.Account] as? [String: AnyObject] {
                    // do something with the result... get the get out...
                    if let userID = result[JSONResponseKeys.AccountKey] {
                        // self.userID = userID as! String? -> don't do it here, do it when userID got passed back to func authenticaticatewithViewController's (from completionHandlerForGETUserID to whenever calling .getUserID (see below line)
                        completionHandlerForGETUserID(true, userID as! String, nil )
                    } else {
                        print("Could not find \(JSONResponseKeys.UserID) in \(results)")
                        completionHandlerForGETUserID(false, nil, "There is no User ID returned! (User ID")
                    }
                } // end of if let result = results?
            } // end of else
        } // end of taskForPOSTMethod
    } // end of func  getUserID
    
//        var mutableMethod: String =
//        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
        
    
              // add completion handler to pass "errorString" + "success" -> but where am i handling the data???? I need to get the unique key = user id. and store it to struct [Student]
        // can get completion handler - listen to : "error", if status is not "2xx", then grab the error and display - {"status": 403, "error": "Account not found or invalid credentials."}
       
        // this func should call UdacityClient.sharedInstance() - 1. getsession() + 2. getPublicUserData()
    
        
        // "account@domain.com\"   "spacenikki@gmail.com"
  
    
//
//            print(result["account"]
//            
//            if let results = results?[TMDBClient.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
//                
          
            // error:
            // POST Session's result ...{"status": 403, "error": "Account not found or invalid credentials."}
            // success:
//            {"account": {"registered": true, "key": "116975484"}, "session": {"id": "1520644666S09af9ceea586d4ebeffa77882738c033", "expiration": "2017-05-09T01:17:46.560370Z"}}
    
        // authenticateWithUserCredentials(pass the result from what i get)
        
        
        // should call getpublicData() here, parsing "unqiue key", store it to struct [student]'s unique key.
      
        // after setting up the taskForPOSTMethod..do below
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        /* 2. Make the request */
        /* 3. Send the desired value(s) to completion handler */
        // grab the session id here from result..
        // there is no need to pass session id around to next function, so no need to write completion handler
        
    
    
    func getPublicUserData(_ completionHandlerForGetPublicData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ erroString: String?) -> Void) {
        // GET request; need taskForGETMethod -> https://www.udacity.com/api/users/3903878747 -> need substituteKeyInMethod to add userID to it. -> "/users" passed as methods (later as withPathExtension  -> no need for parameters!
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        // don't need to set any parameter because there is no &limit=100 etc..
        let parameters = [String: AnyObject]()
        
        self.baseURL = "udacity"
        
        // need substituteKeyInMethod to hard code  - i need to set its value on Udacityclient class! and remove
        var mutableMethod: String = Methods.PublicData //https://www.udacity.com/api/users/id   static let PublicData = "/users/{id}"
       // print(UdacityClient.sharedInstance().userID) // Optional("3903878747") hard coded @ UdacityClient.swift
        
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID , value: UdacityClient.sharedInstance().userID!)!
        print("mutableMethod after transformation of substituteKey is .. \(mutableMethod)")
       // mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: UdacityClient.sharedInstance().userID!)!  // right now hard code it as "3903878747" at UdacityClient.swift
        
        /* {
         "user":{
         "last_name":"Doe", "_facebook_id":null, "timezone":null, "site_preferences":null, "occupation":null, "_image":null, "first_name":"John", "jabber_id":null, "languages":null, "mailing_address":null}
         }
         */
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in  // this error is from convertdataCompletionHandler.
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetPublicData(false, nil, nil, "Can't retrieve User's public data!")
            } else { // either have data, can OR cannot parse!
                print("results from getUserPublicData is \(results)")
                if let user = results?[JSONResponseKeys.User] as? [String:AnyObject] {
                    if let firstName = user[JSONResponseKeys.firstName], let lastName = user[JSONResponseKeys.lastName] {
                        completionHandlerForGetPublicData(true, firstName as! String, lastName as! String, nil)
                    } else {  /// there is no user info at all!
                        completionHandlerForGetPublicData(false, nil, nil, "There is no result called 'User' at all!")
                    } // end of if let firstName = user
                } // end of if let user = results
            } // end of else
        } // end of taskForGETMethod
    } // end of func getPublicUserData
    
    
    
    
//        Original codes from playground:
//        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/116975484")!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            let range = Range(uncheckedBounds: (5, data!.count - 5))
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//        }
//        task.resume()
////        completionHandlerForGetPublicData(true, 12, errostring)
    
        
        
        
    
    
    func getStudentsLocations(_ completionHandlerForGetStudentLocations: @escaping (_ results: [StudentLocation]?, _ error: NSError?) -> Void){
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [String: AnyObject]()
        parameters[ParameterKeys.Limit] = ParameterValues.Limit as AnyObject?  // ex: limit=100
        parameters[ParameterKeys.Skip] = ParameterValues.Skip as AnyObject?
        parameters[ParameterKeys.Order] = ParameterValues.Order as AnyObject?
        
//         print("parameters is ... from getstudentslocations \(parameters)")
        self.baseURL = "parse"
        
        // add print statement @ studentURLfrom parameter -> to help testing
        // https://parse.udacity.com/parse/classes/StudentLocation?skip=400&limit=100&order=-updatedAt
        let mutableMethod: String = Methods.StudentLocation   // no need to call substitueKeyInMethod because I don't need to pass user_id like this : https://parse.udacity.com/parse/classes/StudentLocation/USERID
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String: AnyObject]) { (results, error) in  // (results, error) returned back from "completionHandlerForGET" to here - which was passed by the data returned from completionHandlerForGET to "completionHandlerForGET"
            
            /* 3. Send the desired value(s) to completion handler */
            /* @ func taskForGETMethod, only take care of the "raising error" action on data, response, error from performing datatask call.. here, we deal with error/ result from "completionHandlerForConvertData" which returned to completionHandlerForGET -> then return to here "taskForGETMethod"
            completionHandlerForConvertData is - parsedResult is returned -> completionHandlerForConvertData(parsedResult, nil)
            if error: completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo)  */
            
            if let error = error {  // this error is not from datatask. it's from "func convertDataWithCompletionHandler's completionHandlerForConvertData(result, error)" - ex: completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                completionHandlerForGetStudentLocations(nil, error)
            } else {
                // there is no error...-> 1. can parse data or 2. cannot parse data
                
                if let results = results?[JSONResponseKeys.LocationResult] as? [[String: AnyObject]] { // results on the right side is the results being passed from completionHandlerForGET - ex: {"results":[{"objectId":"oWtekKx1UU","latitude":
                
                    
                    // transform my result to a dictionary with more structed studentlocation preset by struct [StudentLocation] & StudentsLocationsFromResults @ UdacityStudentLocation - now open another UdacityStudentLocation.swift to build func StudentsLocationsFromResults
                    let studentlocations = StudentLocation.StudentsLocationsFromResults(results)
//                    print("inside getstudentslocations \(studentlocations)")
//                    print("count is \(studentlocations.count)") // 100 - right!
                    completionHandlerForGetStudentLocations(studentlocations, nil)
                } else {
                    // if cannot parse the data
                    completionHandlerForGetStudentLocations(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }  // end of let_ = taskForGETMethod
        
        // this func will return lots of things, we only need : user id + fn, ln, and media url only -> when result is done -> check if userid is in any of the result -> if false -> then HTTP METHOD = "POST", else HTTP METHOD = "PUT"
//        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&skip=400&order=-updatedAt")!)
        // moved to taskForGETMethod
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//        }
//        task.resume()
//    }
    
    } // end of func getStudentsLocations
    // v1 - check what is the data type to return - Placemark - is [] array
//    func forwardGeocoding(_ address: String){
//        CLGeocoder().geocodeAddressString(String) { ([CLPlacemark]?, Error?) in
//            code
//        }
//    }

    func forwardGeocoding(_ address: String, _ completionHandlerForGeoCoding: @escaping (_ latitude: Double?, _ longitude: Double?, _ error: NSError?) -> Void) {
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGeoCoding(nil, nil, NSError(domain: "forwardGeocoding", code: 1, userInfo: userInfo)) // this will be passed to InfoPostViewController
            }
            
            if error != nil {
                
                sendError("There was an error with the request: \(error)")
                // when error is returned, it passed to sendError() that triggers to pass no result, and NSerror to completionHandlerForGeoCoding() where is called @ InfoPostVC
    
            } else {
                // break down placemarks (comes back as Array) first before passing over?
                
                if let geoCodeResult = placemarks {
                    print("placemarks is \(geoCodeResult)")
                    let placemark = geoCodeResult[0]
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    let latitude = coordinate?.latitude   // CLLocationDegree is type of Double, not float
                    let longitude = coordinate?.longitude
                    
                    completionHandlerForGeoCoding(latitude, longitude, nil)
                    // pass placemarks to completionhandler... to handle it @ InformationPostingViewController view
                } // end of  "if let geoCodeResult"
            
            } // end of else
        } // end of CLGeocoder().geocodeAddressString
    } // end of func forwardGeocoding
    
    
    // For Mapview @ MediaURL Posting StackView
    // when user clicks "Find on Map", after running func forwardGeocoding, run this.
    func placeAnnotation() -> [MKPointAnnotation] {
        
        var annotationList = [MKPointAnnotation]() // need to create an array because to add annotation, need to use "addAnnotations" - that expects ARRAY
        
        let lat = CLLocationDegrees(UdacityClient.sharedInstance().latitude!)
        let long = CLLocationDegrees(UdacityClient.sharedInstance().longitude!)
        //  is already Double, so no need to convert to match CLLocationDegrees Double "type"
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // add coordinate to annotation - 1 set
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        
        // append annotation (= 1 set) to annotationList
        annotationList.append(annotation)    // able to add pin on map - BUT didn't zoom in..
        
        return annotationList   // pass back to View of MSB, so u can update mapView
        
    } // end of func placeAnnotation
    
    func submitStudentLoc() {
        // call get a student location
        getaStudentloc() { (state, error) in
            if state == "PUT" { // true - have record already
                // call PUT request
                print("state is \(state)")
            } else if state == "POST" {  // false - no record before
                // call POST request
                print("state is \(state)")
            }
        }
    }
    
    func getaStudentloc(_ completionHandlerForGETaStudentLoc: @escaping (_ state: String?, _ errorString: String?) -> Void ) {
       
        // expect url - "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%225555%22%7D"  //uniqueKey = 5555
        
        UdacityClient.sharedInstance().userID = "1234"
        let uniquekey = UdacityClient.sharedInstance().userID!
        
        var parameters = [String: AnyObject!]()
        parameters["where"] = "{\"uniqueKey\":\"\(uniquekey)\"}" as AnyObject??
        // because taskForGETMethod's expected parameters datatype - [String : AnyObject]
        
        print("uniqueKey is ... \(uniquekey)")
        
        print("get a student loc 's parameters is \(parameters)") // result:  ["where": %7B%22uniqueKey%22%3A%223903878747%22%7D] -> value is AnyOject because it's what taskForGetMethod's expecting! Not String! so it's fine
        
        let method = Methods.StudentLocation   // "/classes/StudentLocation"
        
        self.baseURL = "parse"
        
        let _ = taskForGETMethod(method, parameters: parameters as [String : AnyObject]) { (resultback, error) in
            // completionHandlerForGET will come back here - then i will use parsedResult (type: AnyObject), error here @ completionHandlerForGETaStudentLoc (this func!)
            // parsedData
            if let error = error {
                completionHandlerForGETaStudentLoc(nil, "Can't retrieve any record of this login user!")
            } else {
                print("result of this user is \(resultback)")
                
                // resultback -> its datatype from taskForGETMethod is -> "_ result: AnyObject?" ->  {    results:[{ : }, {:}]     } -> To retrieve key [results] - need to 1. convert AnyObject to Dict -> 2. get call Dict[results] -> to see its count!
                
                if let convertedResults = resultback as? Dictionary<String, AnyObject> {
                    print("convertedResults is .. \(convertedResults)")
                    
                    if let loggedInStudentLoc = convertedResults["results"] {
                        print("count is \(loggedInStudentLoc.count)")
                        let count = loggedInStudentLoc.count as Int
                        
                        if count > 1 {
                            completionHandlerForGETaStudentLoc("PUT", nil)
                        } else { // no previous
                            completionHandlerForGETaStudentLoc("POST", nil)
                        }
                        
                    } // end of if let loggedInStudentLoc
                } // end of if let convertedResults
            } // end of else
        } // end of let _ = taskForGETMethod
        // return count back to submitStudentLoc
    }  // end of func getaStudentloc
}  // end of class











