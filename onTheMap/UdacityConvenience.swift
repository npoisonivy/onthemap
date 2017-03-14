//
//  UdacityConvenience.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    // MARK: Authentication (POST) Methods
    //authenticateWithViewController - takes a self viewController because -> in client's side - only one screen, but at the back, there were a lot of things happening - ex: request token, login with Token after token is obtained, etc... but this app is very simple, just need to get a session id in order to make any GET/ POST request
    func authenticateWithUserCredentials(_ username: String, _ password: String, completionHandlerForAuth: @ escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void) {

        /* 1. Specify parameters, method (if has {key}), and HTTP body since it's a POST */
        let parameters = [String:AnyObject]()
        
//        var mutableMethod: String =
//        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
        
//         i can add substitudeKeyinmethod..
//        var mutableMethod: String = Methods.AccountIDFavoriteMovies
//        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        /*
             {"user": {"bio": null, "_registered": true, "linkedin_url": null, "_image": null, "guard": {"allowed_behaviors": ["register", "view-public", "view-short"]}, "location": null, "key": "3903878747", "timezone": null, "_image_url": "//robohash.org/udacity-3903878747.png", "nickname": "John", "website_url": null, "occupation": n

 
 
 */
        // add completion handler to pass "errorString" + "success" -> but where am i handling the data???? I need to get the unique key = user id. and store it to struct [Student]
        // can get completion handler - listen to : "error", if status is not "2xx", then grab the error and display - {"status": 403, "error": "Account not found or invalid credentials."}
       
        // this func should call UdacityClient.sharedInstance() - 1. getsession() + 2. getPublicUserData()
    
        
        // "account@domain.com\"   "spacenikki@gmail.com"
        print("username being passed over is.. \(username)") // username being passed over is.. spacenikki@gmail.com
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        print("request is... \(request)")
        let session = URLSession.shared
        
        // if error -> should i print error here or on LoginViewController?
        // maybe i should bring "error" as a completion handler to LoginViewController....
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            // example of wrong username/ password
            //        {"status": 403, "error": "Account not found or invalid credentials."}
            
            if error != nil { // Handle error…
                return
            }
//            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            let result = NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!
//            
//            print(result["account"]
//            
//            if let results = results?[TMDBClient.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
//                
            print("POST Session's result ...\(result)")
            // error:
            // POST Session's result ...{"status": 403, "error": "Account not found or invalid credentials."}
            // success:
//            {"account": {"registered": true, "key": "116975484"}, "session": {"id": "1520644666S09af9ceea586d4ebeffa77882738c033", "expiration": "2017-05-09T01:17:46.560370Z"}}
            
            
        }
        task.resume()
        
        
        // authenticateWithUserCredentials(pass the result from what i get)
        
        
        // should call getpublicData() here, parsing "unqiue key", store it to struct [student]'s unique key.
      
        // after setting up the taskForPOSTMethod..do below
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        /* 2. Make the request */
        /* 3. Send the desired value(s) to completion handler */
        // grab the session id here from result..
        // there is no need to pass session id around to next function, so no need to write completion handler
        
        
    }
    
//    func getPublicUserData(_ completionHandlerForGetPublicData: @escaping (_ success: Bool, _ userID: Int?, _ erroString: String?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        // don't need to set any parameter because there is no &limit=100 etc..
//        
//        var mutableMethod: String = Methods.U
//        
////        var mutableMethod: String = Methods.AccountIDFavorite
////        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
//        
//        // unique key should be passed from func "authenticateWithUserCredentials"
//        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/116975484")!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            let range = Range(uncheckedBounds: (5, data!.count - 5))
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//            
//            // can you store self.Students.firstname = firstname, self.Students.lastname = lastname obtained from the result?
//        }
//        task.resume()
//        
////        completionHandlerForGetPublicData(true, 12, errostring)
    
        
        
        
    }
    
    func getStudentsLocations(_ completionHandlerForGetStudentLocations: @escaping (_ results: [StudentLocation]?, _ error: NSError?) -> Void){
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [String: AnyObject]()
        parameters[ParameterKeys.Limit] = ParameterValues.Limit as AnyObject?  // ex: limit=100
        parameters[ParameterKeys.Skip] = ParameterValues.Skip as AnyObject?
        parameters[ParameterKeys.Order] = ParameterValues.Order as AnyObject?
        
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
                    completionHandlerForGetStudentLocations(studentlocations, nil)
                } else {
                    // if cannot parse the data
                    completionHandlerForGetStudentLocations(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
        
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
    
    }
}


