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
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
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
        
        print("request is... \(request)")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print("data is....\(data)") // data is....270 bytes
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
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
        // let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        // println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        
        if self.baseURL == "udacity" {  // getUserID (= post session), delete a session, get public data
            var data = data
            let range = Range(uncheckedBounds: (5, data.count))
            data = data.subdata(in: range) /* subset response data! */
            print("data from convertDataWithCompletionHandler's self.baseurl = 'udacity'")
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        
        // it works for self.baseURL = "parse", but not for "udacity"!
        var parsedResult: AnyObject! = nil
        do {
            print("@ do statement... ")
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            // print("parsedResult is ...\(parsedResult)")
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        print("parsedResult is...\(parsedResult) from func convertDataWithCompletionHandler")
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func studentURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        // condition added here... to decide what url to call
       
        print("baseURL is.. \(baseURL)") // applied to both taskForGETMethod & taskForPOSTMethod
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
