//
//  UdacityStudentLocation.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//
import Foundation
// set struct StudentLocation, and a func to proceed lots of StudentLocations collecting from a GET request from xxx.swift
struct StudentLocation {
    
    // Properties
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let userID: String
    
    // Initializers - when Struct StudentLocation is called -> expect to pass [String:AnyObject] -> and what to do with it
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] != nil ? dictionary["firstName"] as! String: ""
        lastName = dictionary["lastName"] != nil ? dictionary["lastName"] as! String : ""
        latitude = dictionary["latitude"] != nil ? dictionary["latitude"] as! Double: 0
        longitude = dictionary["longitude"] != nil ? dictionary["longitude"] as! Double: 0
        mapString = dictionary["mapString"] != nil ? dictionary["mapString"] as! String: ""
        mediaURL = dictionary["mediaURL"] != nil ? dictionary["mediaURL"] as! String: ""
        objectId = dictionary["objectId"] != nil ? dictionary["objectId"] as! String: ""
        // userID = dictionary["uniqueKey"] if not nil, if it's nil, then do ...
        // if dictionary["uniqueKey"] is NSNull -> then set it as String: ""
        if dictionary["uniqueKey"] is NSNull {
            userID = ""
        } else { // if not Null, either have value or not.
            userID = dictionary["uniqueKey"] != nil ? dictionary["uniqueKey"] as! String: ""
        }
        
        // original code: 
        // userID = dictionary["uniqueKey"] != nil ? dictionary["uniqueKey"] as! String: ""
        // error raised as - Could not cast value of type 'NSNull' (0x110f278c8) to 'NSString' (0x10d262c40).
        // Investigation: error raised when one user from response has NULL uniqueKey - result is , ["latitude": 51.5001524, "createdAt": 2018-01-15T10:13:37.687Z, "uniqueKey": <null>, "objectId": HCS88FEI6s, "updatedAt": 2018-01-15T10:13:37.687Z, "firstName": Joshua, "longitude": -0.1262362, "mediaURL": , "lastName": Ajakaiye] -
    }
    
    static func StudentsLocationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        // proceed the result, and transform it to a struct [StudentLocation]
        
        var studentsLocations = [StudentLocation]()   // empty Struct studentLocations that will contain lots of individual [StudentLocation]
        
        for result in results {
            
            print("result is , \(result)")
            studentsLocations.append(StudentLocation(dictionary: result)) // when appending 1. a STRUCT StudentLocation -> append(StudentLocation(....)), it starts 2.to all initialize - means creating a dictionary which is "result" and put matching value to it - i.e. "dictionary: result"
        }
//        print("studentsLocations from StudentsLocationsFromResults is... \(studentsLocations)")
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
    
} // struct StudentLocation
// MARK: Shared Instance  -- A singleton class returns the same instance no matter how many times an application requests it. "StudentModel" is the return object of a singleton
// A class of StudentLocations
class StudentModel {
    var listofStudents: [StudentLocation] = []
    
    class func sharedInstance() -> StudentModel {
        struct Singleton {
            static var sharedInstance = StudentModel()
        }
        return Singleton.sharedInstance
    }
}

