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

//        GET Student Locations - https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt
//        PUTting a Student Location - https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8
//        POSTing a Student Location - https://parse.udacity.com/parse/classes/StudentLocation
//        GETting a Student Location - https://parse.udacity.com/parse/classes/StudentLocation

        
        static let UdacityURL = "https://www.udacity.com/api"
//        https://www.udacity.com/api/session POSTing a Session - WITHOUT FACEBOOK
//        https://www.udacity.com/api/users - GETting Public User Data
//        https://www.udacity.com/api/session - DELETEing a Session
    }
    
    // MARK: Methods
    struct Methods {
        // student location
        static let StudentLocation = "/classes/StudentLocation"
        static let StudentLocationUserIdPut = "/classes/StudentLocation/{UserID}" //  ObjectId = UserID
        
        // udacity - session
        static let Session = "/session"
        static let Users = "/users"
        static let PublicData = "/users/{UserID}"
    }
    
    // MARK: URL Keys - that will be pass in a URL link
    struct URLKeys {
        static let UniqueKey = "uniqueKey" // get a student location
        static let UserID = "id" // get public User Data
        static let ObjectID = "objectid"  // put a student location
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
        static let Limit = "100"
        static let Skip = "400"
        static let Order = "-updatedAt"
       
        
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
        
        // get student locationss
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
        static let AccountKey = "key" // = UniqueKey
        
        // get public data - ?? what do i want to store from the response???
        
    }
    
}
