//
//  UdacityConstants.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

// MARK: - UdacityClient (Constants) 

extension UdacityClient { // Instead of storing them under UdacityClient, I just store UdacityClient's properties here@ this file. To call them, I can just do "UdacityClient.propertyname"
    
    // MARK: Contants
    struct Constants {
        
        // MARK: API Key & Parse Application ID
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        // For func "tmdbURLFromParameters" used @ taskForGETMethod & taskForPOSTMethod - to parse queryItems and etc
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse"
        
        //        GET Student Locations - https://parse.udacity.com/parse/classes/StudentLocation?skip=400&limit=100&order=-updatedAt
        //        PUTting a Student Location - https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8
        //        POSTing a Student Location - https://parse.udacity.com/parse/classes/StudentLocation
        //        GETting a Student Location - https://parse.udacity.com/parse/classes/StudentLocation

        static let UdacityApiScheme = "https"
        static let UdacityApiHost = "www.udacity.com"
        static let UdacityApiPath = "/api"

        // @ func convertDataWithCompletionHandler - add this line - let range = Range(5 ..< data!.count), only for Udacity API
//        https://www.udacity.com/api/session POSTing a Session - WITHOUT FACEBOOK
//        https://www.udacity.com/api/users - GETting Public User Data
//        https://www.udacity.com/api/session - DELETEing a Session
    }
    
    // MARK: Methods
    struct Methods {
        // student location OR get A student location
        static let StudentLocation = "/classes/StudentLocation"
        static let StudentLocationObjectIdPut = "/classes/StudentLocation/{ObjectID}"
        
        // udacity - session
        static let Session = "/session"
        static let Users = "/users"
        static let PublicData = "/users/{id}"
        
    }
    
    // MARK: URL Keys - that will be pass in a URL link
    struct URLKeys {
        static let UniqueKey = "uniqueKey" // get a student location
        static let UserID = "id" // get public User Data
        static let ObjectID = "ObjectID"  // put a student location
    }
    
    // MARK: Parameter Keys - key:value for query...
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let Query = "query" //  needed for making query with ?&
        
        // get student locations
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        
        // get a student location
        static let Where = "where"
        
    }
    
    // MARK: Parameter Keys - key:value for query...
    struct ParameterValues {
        
        // get student locations
        static let Limit = "100" // need to change it back to 100
        static let Skip = "400"
        static let Order = "-updatedAt"
       
        // get a student location
        // check what to put - userid or id ???
        // do i need to replace this ??? because i already have a part to take care of this!
        static let Where = "%7B%22uniqueKey%22%3A%22{userID}%22%7D"
        // "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%225555%22%7D"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        // post a student location + put a student location
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let mediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
        // post a session - login
        static let UserName = "username"
        static let Password = "password"
        
        
    }
        
    struct JSONResponseKeys {
        
        // StudentLocation
        static let LocationResult = "results" // confirm by calling the request, and check the json response - {"results":[{"objectId":"oWtekKx1UU","latitude":
        
        // get student locations
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let mediaURL = "mediaURL"
        static let ObjectID = "objectId"    // + post a student location + post a session - login
        static let UniqueKey = "uniqueKey"
        
        
        // get a student location
        static let MediaURL = "mediaURL"
        
    
        // post a session - login
        static let Session = "session"
        static let SessionID = "id"
        static let AccountKey = "key" // = UserID
        static let User = "user" // Keys from .getUserID
        static let Account = "account"
        static let UserID = "UserID"
        
        
        // get public data
        static let firstName = "first_name"
        static let lastName = "last_name"
        
        // handle error returned inside "data"
        static let Error = "error" // {"status": 403, "error": "Account not found or invalid credentials."}
        
    }
    
}
