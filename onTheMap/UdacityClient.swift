//
//  UdacityClient.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import Foundation
// should store below items:
// data: session, session; taskForGETMethod, taskForPOSTMethod, helper func "substitueKeyInMethod" if we need to pass a var like student_id in the url, converDataWithCompletionHandler (deal with data - ParsedResult), studentURLFromParameters - create a URL from parameters, shareInstance.

class UdacityClient: NSObject { // save loginUser properties here!!
    
    // MARK: Properties
    
    // share session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    var userID: String? = nil // = uniqueKey  - hard code for testing
    
    // from logged in user - must put "nil" or else, error: Instance member '' cannot be used on type 'udacityClass'
    var username: String? = nil
    var password: String? = nil
    var objectID: String? = nil
    
    // from calling GET public data
    var firstName: String? = nil 
    var lastName: String? = nil
    
    // url 
    var baseURL: String? = nil
    
    // GeoCoding
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    var mediaURL: String? = nil
    var location: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init() // why? - to make sure that your code will run...
    }
    
    // MARK: GET
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
//        var parametersWithApiKey = parameters
//        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject? - we don;t need api key
        
        /* 2/3. Build the URL, Configure the request */
        print("parameter is \(parameters)")
        print("method is \(method)")
        print("before studentURLFromParameters")
        let request = NSMutableURLRequest(url: studentURLFromParameters(parameters, withPathExtension: method)) // return a nice url with complete stuff : "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&skip=400&order=-updatedAt"
        // "method" is the part that is outside of base url - like "classes/StudentLocation"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in  // data, response, error are the standard response from a url datatask to expect
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // only to raise error when problem occurs but didn't handle if we got good stuff from it. so we set a completionhandler here "completionHandlerForGET" , so we can call pass good stuff from here back to UdacityConvenience.swift -> getstudentsLocations' "taskForGETMethod" -> "completionHandlerForGET" -> completionHandlerForFavMovies(movies, nil)
//            let task = session.dataTask(with: request as URLRequest) { (data, response, error)
            
            
            /* GUARD: Was there an error? - error from datatask call*/
            guard (error == nil) else {
                if let error = error {
                    print(error)
                    sendError("\(error.localizedDescription)")
                    // sendError("There was an error with your request: \(error)")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // print("data is ", NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError( (NSString(data: data, encoding: String.Encoding.utf8.rawValue)!) as String)
                // sendError("Your reqest returned a stauts code other than 2xx!" + ((NSString(data: data, encoding: String.Encoding.utf8.rawValue)!) as String))
                return
            }
            
         
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET) // parsedData returned to completionHandlerForConvertData: completionHandlerForGET -> parsedData, error passed to "completionHandlerForGet -> then it returned back to where taskForGetMethod is called!
            
            // process:
            /* 1. @ func convertDataWithCompletionHandler ->   private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) { ->  we got "parseddata" from data after JSONSerialization
               2. @ completionHandlerForConvertData(parsedResult, nil) -> pass parsedResult to wherever calling func convertDataWithCompletionHandler RIGHT NOW -> which is right here @ UdacityClient "self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)"
             sp parsed data is passed to self.convertDataWithCompletionHandler as "data"
             3. completionHandlerForGET is expecting "result" and it is actually the "data" here
            completionHandlerForConvertData is - parsedResult is returned -> completionHandlerForConvertData(parsedResult, nil) 
             if error: completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo)
                         self.convertDataWithCompletionHandler(data, parsedresult & error)
           */
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    // MARK: POST
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters - we don't need this as no need to add apiKey for this project*/
//        var parametersWithApiKey = parameters
//        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: studentURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)   // taskForPOSTMethod expects input "jsonBody"
        
        print("jsonBody is below")
        print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!)
        
        print("request is... \(request)")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print(error)
                // unwrap "optional" error (since Guard ... already save value to error.
                if let error = error {
                    sendError("\(error.localizedDescription)")
                }
                // sendError("error is \(error?.localizedDescription)")
                // sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            // after passing "guard let data = data" - means data != nil now
            print("guard let data -", NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            /* GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            } */
            
            print("data is....\(data)") // data is....270 bytes
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)  // completion handler to pass is "completionHandlerForPOST"
            // which is (parsedResult, nil) from completionHandlerForConvertData(parsedResult, nil)
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    } // end of POST request
    
    // MARK: PUT  --
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters - we don't need this as no need to add apiKey for this project*/
        //        var parametersWithApiKey = parameters
        //        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: studentURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)   // taskForPOSTMethod expects input "jsonBody"
        
        print("jsonBody is below")
        print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!)
        
        print("request is... \(request)")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            // after passing "guard let data = data" - means data != nil now
            print("data from HTTP PUT method is ", NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            print("data is....\(data)") // data is....40 bytes
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    } // end of PUT request

    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        print("mutableMethod before transformation of substituteKey is .. \(method)")
        print(key)
        print(value)
        
        if method.range(of: "{\(key)}") != nil {
            print("mutableMethod before transformation of substituteKey is .. \(method)")
            
            print("mutableMethod after transformation of substituteKey is .. \(method.replacingOccurrences(of: "{\(key)}", with: value))")
            
            return method.replacingOccurrences(of: "{\(key)}", with: value)
            
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        print("self.baseURL is", self.baseURL)
//        print("Data just got passed to func convertDataWithCompletionHandler is ...", data)
        
        var newData: Data = data
        var parsedResult: AnyObject! = nil
        
        if self.baseURL == "udacity" {
            let range = Range(uncheckedBounds: (5, data.count)) // start reading from 5th index
            newData = data.subdata(in: range) /* subset response data! */
//            print("newData after cutting range is",NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        }

        do {
            print("@ do statement... ")
            
            print("userID is , \(userID)")
//            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)  // if self.baseURL == "udacity - should not have ")]}'" anymore!
            
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            // print(parsedResult)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        } // END of Do/Catch block
        
//        print("parsedResult is...\(parsedResult) from func convertDataWithCompletionHandler")
        completionHandlerForConvertData(parsedResult, nil)
    } // END of func convertDataWithCompletionHandler
    
    // create a URL from parameters
    private func studentURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        // condition added here... to decide what url to call
       
        print("baseURL is.. \(self.baseURL)") // applied to both taskForGETMethod & taskForPOSTMethod
        var components = URLComponents()
        
        if baseURL == "parse" {   // ApiHost = "parse.udacity.com"
            print("parse.udacity.com is called")
            components.scheme = UdacityClient.Constants.ApiScheme
            components.host = UdacityClient.Constants.ApiHost
            components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
            
        } else {   // UdacityApiHost = "udacity.com"
            print("udacity.com is called")
            components.scheme = UdacityClient.Constants.UdacityApiScheme
            components.host = UdacityClient.Constants.UdacityApiHost
            components.path = UdacityClient.Constants.UdacityApiPath + (withPathExtension ?? "")
        }
        components.queryItems = [URLQueryItem]()
        print("after components.queryItems is \(components)")
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            print("queryItem inside for (key,value) is \(queryItem)")
            components.queryItems!.append(queryItem)
            print("queryItemS inside for (key,value) is \(components.queryItems)")
        }
        print("after key/ value in parameter processing...")
        print("url is... \(components.url)")
        return components.url!
        
    }

    // MARK: Shared Instance  -- A singleton class returns the same instance no matter how many times an application requests it. "UdacityClient" is the return object of a singleton
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
