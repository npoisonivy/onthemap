//
//  UdacityStudentLocation.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

// set struct StudentLocation, and a func to proceed lots of StudentLocations collecting from a GET request from xxx.swift
struct StudentLocation {
    
    // Properties
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let userID: Int
    
    // Initializers - when Struct StudentLocation is called -> expect to pass [String:AnyObject] -> and what to do with it
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Float
        longitude = dictionary["longitude"] as! Float
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectId = dictionary["objectId"] as! String
        userID = dictionary["uniqueKey"] as! Int
    }
    
    static func StudentsLocationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        // proceed the result, and transform it to a struct [StudentLocation]
        
        var studentsLocations = [StudentLocation]()   // empty Struct studentLocations containing lots of individual [StudentLocation]
        
        for result in results {
            studentsLocations.append(StudentLocation(dictionary: result)) // when appending 1. a STRUCT StudentLocation -> append(StudentLocation(....)), it starts 2.to all initialize - means creating a dictionary which is "result" and put matching value to it - i.e. "dictionary: result"
        }
        
        return studentsLocations
        
        
        /*
         {
         "results":[
         {
         "createdAt": "2015-02-25T01:10:38.103Z",
         "firstName": "Jarrod",
         "lastName": "Parkes",
         "latitude": 34.7303688,
         "longitude": -86.5861037,
         "mapString": "Huntsville, Alabama ",
         "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
         "objectId": "JhOtcRkxsh",
         "uniqueKey": "996618664",
         "updatedAt": "2015-03-09T22:04:50.315Z"
         }
         {
         "createdAt":"2015-02-24T22:27:14.456Z",
         "firstName":"Jessica",
         "lastName":"Uelmen",
         "latitude":28.1461248,
         "longitude":-82.756768,
         "mapString":"Tarpon Springs, FL",
         "mediaURL":"www.linkedin.com/in/jessicauelmen/en",
         "objectId":"kj18GEaWD8",
         "uniqueKey":"872458750",
         "updatedAt":"2015-03-09T22:07:09.593Z"
         },
         {
         "createdAt":"2015-02-24T22:30:54.442Z",
         "firstName":"Jason",
         "lastName":"Schatz",
         "latitude":37.7617,
         "longitude":-122.4216,
         "mapString":"18th and Valencia, San Francisco, CA",
         "mediaURL":"http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
         "objectId":"hiz0vOTmrL",
         "uniqueKey":"2362758535",
         "updatedAt":"2015-03-10T17:20:31.828Z"
         },
 
         */
        
    }
}


