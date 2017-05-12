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
        
//        // call .getPublicUserData below:
        getPublicUserData() { (success, firstName, lastName, errorString) in
            guard (errorString == nil) else {
                completionHandlerForAuth(false, errorString) // pass error of getPublicUserData() to one layer up -> Auth
                print("User doesn't seem to have firstname/ lastname from getPublicUserData")
                return
            }
            // success - result returns to here... - get firstname, and lastname, and saved to UdacityClient.sharedInstance().firstname
            print("data passed from .getPublicData - firstname is ... \(firstName) & lastname is ... \(lastName)")
            // we should store the data is success
            if success {  // no need to send success/ erro back to LoginVC as it does not affect user logging in..
                UdacityClient.sharedInstance().firstName = firstName
                UdacityClient.sharedInstance().lastName = lastName
                completionHandlerForAuth(true, nil)
            }
        } // END of getPublicUserData()
        
        // need to pass completionHandlerForAuth(success, errorString) back to loginVC (MSB) swift file - to either completelogin() or to displayError
    
        // Comment below all to now only test out. should place it inside func getPublicData() call, now, temp hardcoded user_id
        // call 2. getUserID - check if it works...
        
        print("username from textfield is \(username)") // check if I successfuly save/ retrieve username, then i can pass it to .getUserID(username, pw)
//        UdacityClient.sharedInstance().username - pass to UdacityClient already
        //
        
        
        /* DO I NEED THIS????
        if success {
            print("UserID is... \(userID)")
            self.userID = userID  // self = current func authenticateWithViewController
            
            // do i need to pass completionHandlerForAuth(success, errorString)?
            
            
            // pass userID to getPublicData... - add it after testing purely getUserID
            
        } else {
            completionHandlerForAuth(success, errorString)  // pass "can't retrieve user id" from .getUserID
        }
    } // end of .getUserID
    */
    
    
        // must pass the (completionHandlerForAuth: xxx, xxx) - so the LoginVC where .authenticateWithViewController is calling - can receive the returned "success/ errostring" - and upon those return, either completeLogin() or displayError will be called

        
    } // end of authenticateWithViewController
    
    func getUserID(_ username: String, _ password: String, _ completionHandlerForGETUserID: @ escaping (_ success: Bool, _ userID: String?, _ errorString: String?) -> Void) {

        // screen off the username/ password
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body since it's a POST - ONLY need: normal method: https://www.udacity.com/api/session;  no need to add any parameter k:v, no need for substituteKeyInMethod */
        let parameters = [String:AnyObject]()
 
        print("username being passed over is.. \(username)") // username being passed over is.. spacenikki@gmail.com
        print("password being passed over is.. \(password)")
        
        self.baseURL = "udacity"  // change the self.baseURL that func "studentURLFromParameters" reads it and return the corresponding APIScheme, APIHost, APIPath
        let method: String = Methods.Session
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        print("***jsonBody is ..\(jsonBody)") // jsonBody is ..{"udacity": {"username": "xxxx@gmail.com", "password": "xxxxx"}} -> not matching what we wanted...
    
        /* Original @ playground:
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8) */
        
        /* 2. Make the request - [pass everything from above to taskForPOSTMethod*/
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            print("taskForPOSTMethod is call once")
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGETUserID(false, nil, "Login Failed (Can't retrieve User ID!).")   // pass errorString to one layer up to getUserID()
            } else {
                /* { "account":{ "registered":true, "key":"3903878747" }, "session":{ "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088", "expiration":"2015-05-10T16:48:30.760460Z" } } */
                if let result = results?[JSONResponseKeys.Account] as? [String: AnyObject] {
                    // do something with the result... get the get out...
                    print("result is, ", result)
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
        
/* return userID from getUserID -> pass this to func getPublicUserData
    UdacityClient.sharedInstance().getUserID(UdacityClient.sharedInstance().username!, UdacityClient.sharedInstance().password!, { (success, userID, errorString) in
    // deal with success, userID returned back to here
    print("userID is", userID)
    UdacityClient.sharedInstance().userID = userID
    
    }) // END of UdacityClient.sharedInstance().getUserID(  */
    
    func getPublicUserData(_ completionHandlerForGetPublicData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ erroString: String?) -> Void) {
        UdacityClient.sharedInstance().getUserID(UdacityClient.sharedInstance().username!, UdacityClient.sharedInstance().password!, { (success, userID, errorString) in
                guard (errorString == nil) else {
                    print("There was an error with your request: \(errorString)")
                    completionHandlerForGetPublicData(false, nil, nil, errorString) // enables errorString from getUserID passed one layer up to getPublicUserData from getUserID()
                    return
                }
     
                // deal with success, userID returned back to here
                print("userID is", userID)
                UdacityClient.sharedInstance().userID = userID
            
            
                // ONLY if after userID is returned, then start calling http request for getPublidUserData
                // GET request; need taskForGETMethod -> https://www.udacity.com/api/users/3903878747 -> need substituteKeyInMethod to add userID to it. -> "/users" passed as methods (later as withPathExtension  -> no need for parameters!
                /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
                // don't need to set any parameter because there is no &limit=100 etc..
                let parameters = [String: AnyObject]()
                
                self.baseURL = "udacity" // belongs to func getPublicUserData()
                
                // need substituteKeyInMethod to hard code  - i need to set its value on Udacityclient class! and remove
                var mutableMethod: String = Methods.PublicData //https://www.udacity.com/api/users/id   static let PublicData = "/users/{id}"
                // print(UdacityClient.sharedInstance().userID) // Optional("3903878747") hard coded @ UdacityClient.swift
                
                mutableMethod = self.substituteKeyInMethod(mutableMethod, key: URLKeys.UserID , value: UdacityClient.sharedInstance().userID!)!
                //        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: UdacityClient.sharedInstance().userID!)!  // right now hard code it as "3903878747" at UdacityClient.swift
                
                /* {
                 "user":{
                 "last_name":"Doe", "_facebook_id":null, "timezone":null, "site_preferences":null, "occupation":null, "_image":null, "first_name":"John", "jabber_id":null, "languages":null, "mailing_address":null}
                 }
                 */
                
                /* 2. Make the request */
                let _ = self.taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in  // this error is from convertdataCompletionHandler.
                    
                    /* 3. Send the desired value(s) to completion handler */
                    if let error = error {
                        completionHandlerForGetPublicData(false, nil, nil, "Can't retrieve User's public data!")
                    } else { // either have data, can OR cannot parse!
//                        print("results from getUserPublicData is \(results)")
                        if let user = results?[JSONResponseKeys.User] as? [String:AnyObject] {
                            if let firstName = user[JSONResponseKeys.firstName], let lastName = user[JSONResponseKeys.lastName] {
                                completionHandlerForGetPublicData(true, firstName as! String, lastName as! String, nil)
                            } else {  /// there is no user info at all!
                                completionHandlerForGetPublicData(false, nil, nil, "There is no result called 'User' at all!")
                            } // end of if let firstName = user
                        } // end of if let user = results
                    } // end of else
                } // end of taskForGETMethod

            
        }) // END of UdacityClient.sharedInstance().getUserID(
        
        
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
        
        print("getStudentsLocations is called")
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [String: AnyObject]()
        parameters[ParameterKeys.Limit] = ParameterValues.Limit as AnyObject?  // ex: limit=100
//        parameters[ParameterKeys.Skip] = ParameterValues.Skip as AnyObject?
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
                    // studentlocations is - [(),(),()] - [(firstName: "Michael", lastName: "Stram", ..), (firstName: "Michael", lastName: "Stram", latitude: 41.883229, longitude: 0.0, mapString: "Chica)]
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
    func placeAnnotation() -> ([MKPointAnnotation], CLLocationCoordinate2D) {
        
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
        
        return (annotationList, coordinate)   // pass back to View of MSB, so u can update mapView
        
    } // end of func placeAnnotation
    
    
    func submitStudentLoc(_ completionHandlerForSubmitStudentLoc: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
       // call get a student location
        getaStudentloc() { (state, error) in   // state will be either
            if let error = error {   // if error != nil
                print(error)  // "Can't retrieve any record of this login user!
                completionHandlerForSubmitStudentLoc(false, error)
                
            } else {  // has to be either PUT / POST
                print("state is \(state)")
                
                if state == "PUT" { // true - have record already
                    // PASS "state" to Add alertViewcontroller to display "overwrite?" -
//                    completionHandlerForSubmitStudentLoc("??", "put")
                    
                    // call PUT request
                    self.putAStudentLoc(){(success, error) in
                        // handles success, error
                        if let error = error {
                            print(error)
                            completionHandlerForSubmitStudentLoc(false, error)
                        } else { // success
                            print("A new record has replaced the old one")
                            completionHandlerForSubmitStudentLoc(true, nil)
                        } // end of if/else block
                    } // end of self.putAStudentLoc()
                    
                } else if state == "POST" {  // false - no record before
                    // call POST a student location request
                    print("UserID \(UdacityClient.sharedInstance().userID)) firstname is \(UdacityClient.sharedInstance().firstName)  lastname is \(UdacityClient.sharedInstance().lastName) objectID is \(UdacityClient.sharedInstance().objectID)")
                    
                    self.postAStudentLoc(){(success, objectID, error) in   // elements passed from completionHandlerForPostAStudentLoc
                        // done with POST request ALREADY - so now, let's deal with success, objectID, error here
                        if let error = error {  // error != nil
                            print(error)
                            completionHandlerForSubmitStudentLoc(false, error)
                        }
                        if let objectID = objectID { // no error, only success!
                            print("POST a student location request is successfuly, object id is", objectID)
                            completionHandlerForSubmitStudentLoc(true, nil)
                        }
                    } // end of self.postAStudentLoc()
                }  /* end of else if state == "POST" */
            } // end of else {state comparison} inside "getaStudentloc()"
        }  // end of getaStudentloc()
    } // end of func submitStudentLoc()
    
    // MARK : postAStudentLoc()
    func postAStudentLoc(_ completionHandlerForPostAStudentLoc: @escaping (_ success: Bool, _ objectID: String?, _ errorString: String?) -> Void) {  // need completion handler - to see if successul or not.. object or..
        print("UserID \(UdacityClient.sharedInstance().userID)) firstname is \(UdacityClient.sharedInstance().firstName)  lastname is \(UdacityClient.sharedInstance().lastName) objectID is \(UdacityClient.sharedInstance().objectID)")
        
        // 1. prepare para, baseURL, method, jsonBody (if post)
        // parameters - nothing
        let parameters = [String:AnyObject]()
        
        // baseURL
        self.baseURL = "parse"  // takes care of https://parse.udacity.com/parse
        
        //method
        // I want - "https://parse.udacity.com/parse/classes/StudentLocation"
        let method: String = Methods.StudentLocation  // /classes/StudentLocation
        
//        UdacityClient.sharedInstance().userID = "179" // test for brand new POST call
//        UdacityClient.sharedInstance().firstName = "Jennifer"
//        UdacityClient.sharedInstance().lastName = "Aniston" // temp - as lastname was "nil"
        
        /* jsonbody - copy the parts from playground to here - "!" if not added -
        cause error - "number not found */
        let firstname = UdacityClient.sharedInstance().firstName!
        let lastname = UdacityClient.sharedInstance().lastName!
        let uniqueKey = UdacityClient.sharedInstance().userID!
        let mapString = UdacityClient.sharedInstance().location!
        let mediaURL = UdacityClient.sharedInstance().mediaURL!
        let latitude = UdacityClient.sharedInstance().latitude!
        let longitude = UdacityClient.sharedInstance().longitude!
        
        let jsonBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstname)\", \"lastName\": \"\(lastname)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
            // delete .data(using: String.Encoding.utf8) here , as func taskForPOSTMethod will add that to the body!
        
        // 2. make the request
        // call let _ = taskForPOSTMethod - where handles POST method, addValye, httpbody ... and call .dataTask for http request
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            print("POST Session's result of func postAStudentLoc ...\(results)") // result return from HTTP POST request's completion handler
            
            // 3. Send the desired value(s) to completion handler
            // response will be :
            // if success -
            // {"objectId":"oVitymDNEi","createdAt":"2017-04-22T00:59:02.187Z"} - this can be "result"
            // if fail -
            // {"code":111,"error":"schema mismatch for StudentLocation.longitude; expected Number but got String"}

            if let error = error {
                completionHandlerForPostAStudentLoc(false, nil, "Post a Student Location request failed" )
            } else {  // no error
//                success: Bool, _ objectID: String?, _ errorString:
                // grab the objectID out
                if let objectID = results?["objectId"] as? String {
                    completionHandlerForPostAStudentLoc(true, objectID as! String, nil)
                } else {
                    print("Could not parse ObjectID in \(results)")
                    completionHandlerForPostAStudentLoc(false, nil, "There is no Object ID returned! (when posting a student location")
                } // end of else inside else
            } // end of else inside let _ =
        } // end of let _ =
    } // end of func postAStudentLoc
    
    // MARK : putAStudentLoc()
    func putAStudentLoc(_ completionHandlerForPUTAStudentLoc: @escaping (_ success: Bool, _ errorString: String?) -> Void) {  // need completion handler - to see if successul or not.. object or..
        
        // Sample link - "https://api.parse.com/1/classes/StudentLocation/8ZExGR5uX8"
        
        // 1. prepare para, baseURL, method, jsonBody (if post)
        // parameters - nothing
        let parameters = [String:AnyObject]()
        
        // baseURL
        self.baseURL = "parse"  // takes care of https://parse.udacity.com/parse
        
        //method
        // I want - "https://parse.udacity.com/parse/classes/StudentLocation"
        var mutableMethod: String = Methods.StudentLocationObjectIdPut  // "/classes/StudentLocation/{ObjectID}"
        
        // UdacityClient.sharedInstance().objectID = "zrYUd9LFtb"
//        UdacityClient.sharedInstance().objectID = "hhh"
        
        // call substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.ObjectID, value: UdacityClient.sharedInstance().objectID!)!
        print("mutableMethod is ", mutableMethod)
//        UdacityClient.sharedInstance().firstName = "Macro"
//        UdacityClient.sharedInstance().lastName = "Polo" // temp - as lastname was "nil" -> cause statuscode != 2xx when putting request made
        
        // jsonbody - copy the parts from playground to here
        let firstname = UdacityClient.sharedInstance().firstName!
        let lastname = UdacityClient.sharedInstance().lastName! // add "!" to avoid optional input to the PUT request - if not, it will be
        let uniqueKey = UdacityClient.sharedInstance().userID!
        let mapString = UdacityClient.sharedInstance().location!
        let mediaURL = UdacityClient.sharedInstance().mediaURL!
        let latitude = UdacityClient.sharedInstance().latitude!
        let longitude = UdacityClient.sharedInstance().longitude!
        
        let jsonBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstname)\", \"lastName\": \"\(lastname)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        // delete .data(using: String.Encoding.utf8) here , as func taskForPOSTMethod will add that to the body!
        
        // 2. make the request
        // call let _ = taskForPOSTMethod - where handles POST method, addValye, httpbody ... and call .dataTask for http request
        let _ = taskForPUTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            print("PUT Session's result of func putAStudentLoc ...\(results)") // result return from HTTP POST request's completion handler
            
            // 3. Send the desired value(s) to completion handler
            // response will be :
            // if success -
            // {"updatedAt":"2015-03-11T02:56:49.997Z"} - this can be "result"
            // if fail -
            // {"code":101,"error":"Object not found."} - checked at playground and see what will be the result
            
            // when statusCode is 404 - it will still send result - result wont come here but under "dataTask"
            // need to reconstruct below according to what result to return from the PUT request
            if let error = error {  // this error (occurs when sending out request, amd a faieled request will have this error) is != as error from server
                completionHandlerForPUTAStudentLoc(false, "Put a Student Location request failed" )
            } else {  // no error
                //  success: Bool, _ errorString: - result: {"updatedAt":"2017-04-25T05:58:44.619Z"}
                completionHandlerForPUTAStudentLoc(true, nil)
            } // end of else inside let _ =
        } // end of let _ =
    } // end of func postAStudentLoc
    
    func getaStudentloc(_ completionHandlerForGETaStudentLoc: @escaping (_ state: String?, _ errorString: String?) -> Void ) {
       
        // expect url - "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%225555%22%7D"  //uniqueKey = 5555
        
//         UdacityClient.sharedInstance().userID = "1234" // PUT
//        UdacityClient.sharedInstance().userID = "22"  // POST - no record before - error: {"error":"Unexpected number"}
//        UdacityClient.sharedInstance().userID = "555" // POST
        print("UdacityClient.sharedInstance().userID is ...", UdacityClient.sharedInstance().userID)
        // UdacityClient.sharedInstance().userID = "178"
        let uniquekey = UdacityClient.sharedInstance().userID!
        print("uniquekey is \(uniquekey)")
        
//        let uniquekey = UdacityClient.sharedInstance().userID! - uncomment it after deleting above hard coded ones
        
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
            if let error = error {  // means if error != nil
                completionHandlerForGETaStudentLoc(nil, "GET- Can't retrieve any record of this login user!")
            } else {
                print("result of this user is \(resultback)")
                // resultback -> its datatype from taskForGETMethod is -> "_ result: AnyObject?" ->  {    results:[{ : }, {:}]     } -> To retrieve key [results] - need to 1. convert AnyObject to Dict -> 2. get call Dict[results] -> to see its count!
                
                if let convertedResults = resultback as? Dictionary<String, AnyObject> {
                    print("convertedResults is .. \(convertedResults)")
//                    var emptyArray: [Int] = []
                    if let loggedInStudentLoc = convertedResults["results"] as? [AnyObject] { //to array
                        print("count is \(loggedInStudentLoc.count)")
                        let count = loggedInStudentLoc.count as Int
                        
                        if count > 0 {
                            // grab the objectID out
                            print(loggedInStudentLoc[0])
                            if let objectID = loggedInStudentLoc[0]["objectId"] as? String {
                                UdacityClient.sharedInstance().objectID = objectID // save it
                                completionHandlerForGETaStudentLoc("PUT", nil)
                            } else {
                                print("Could not parse ObjectID in \(loggedInStudentLoc[-1])")
                                completionHandlerForGETaStudentLoc(nil, "There is no objectID captured")
                            } // end of else inside else
                        } else { // no previous record
                            completionHandlerForGETaStudentLoc("POST", nil)
                        } // end of if/else
                    } /* end of if let loggedInStudentLoc */ else {
                        // if there is error parsing result
                        completionHandlerForGETaStudentLoc(nil, "Cannot parse result's length")
                    } // end of else of
                } // end of if let convertedResults
            } // end of else
        } // end of let _ = taskForGETMethod
        // return count back to submitStudentLoc
    }  // end of func getaStudentloc
    
    // deleteSession when logout is confirmed
    func deleteASession() -> Void {
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
}  // end of class











