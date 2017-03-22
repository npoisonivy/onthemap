//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true
//
//let urlString = "http://quotes.rest/qod.json?category=inspire"
//let url = URL(string: urlString)
//let request = NSMutableURLRequest(url: url!)
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error
//        return
//    }
//    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()

// POSTing a Session - WITHOUT FACEBOOK
let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Accept")
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = "{\"udacity\": {\"username\": \"spacenikki@gmail.com\", \"password\": \"wifi=123\"}}".data(using: String.Encoding.utf8)

let session = URLSession.shared
let task = session.dataTask(with: request as URLRequest) { data, response, error in
    if error != nil { // Handle error…
        return
    }
    let range = Range(uncheckedBounds: (5, data!.count - 5))
    let newData = data?.subdata(in: range) /* subset response data! */
    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
}
task.resume()
//
//// DELETEing a Session
//let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//request.httpMethod = "DELETE"
//var xsrfCookie: HTTPCookie? = nil
//let sharedCookieStorage = HTTPCookieStorage.shared
//for cookie in sharedCookieStorage.cookies! {
//    if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//}
//if let xsrfCookie = xsrfCookie {
//    request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//}
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error…
//        return
//    }
//    let range = Range(uncheckedBounds: (5, data!.count - 5))
//    let newData = data?.subdata(in: range) /* subset response data! */
//    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()

//
//// Get Student Locations - do u need to specify max 100 students' data to be retrieved ?

//let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&skip=400&order=-updatedAt")!)
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//
//print("request's url is \(request.url)")
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error...
//        return
//    }
//    let range = Range(uncheckedBounds: (5, data!.count - 5))
//    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()

//// GETting a Student Location
//let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
//let url = URL(string: urlString)
//let request = NSMutableURLRequest(url: url!)
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error
//        return
//    }
//    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()
//
//// POSTing a Student Location
//let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//request.httpMethod = "POST"
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error…
//        return
//    }
//    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()
//
//// PUTting a Student Location
//let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
//let url = URL(string: urlString)
//let request = NSMutableURLRequest(url: url!)
//request.httpMethod = "PUT"
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: String.Encoding.utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error…
//        return
//    }
//    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}

//
//// POSTing a Session - WITH Facebook
//let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//request.httpMethod = "POST"
//request.addValue("application/json", forHTTPHeaderField: "Accept")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"facebook_mobile\": {\"access_token\": \"DADFMS4SN9e8BAD6vMs6yWuEcrJlMZChFB0ZB0PCLZBY8FPFYxIPy1WOr402QurYWm7hj1ZCoeoXhAk2tekZBIddkYLAtwQ7PuTPGSERwH1DfZC5XSef3TQy1pyuAPBp5JJ364uFuGw6EDaxPZBIZBLg192U8vL7mZAzYUSJsZA8NxcqQgZCKdK4ZBA2l2ZA6Y1ZBWHifSM0slybL9xJm3ZBbTXSBZCMItjnZBH25irLhIvbxj01QmlKKP3iOnl8Ey;\"}}".data(using: String.Encoding.utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error...
//        return
//    }
//    let range = Range(uncheckedBounds: (5, data!.count - 5))
//    let newData = data?.subdata(in: range) /* subset response data! */
//    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()

//
// GETting Public User Data - works!
//let request = NSMutableURLRequest(url: URL(string: "https://www.parse.udacity.com/api/users/3903878747")!)
//let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//    if error != nil { // Handle error...
//        return
//    }
//    let range = Range(uncheckedBounds: (5, data!.count - 5))
// forum says: let range = Range(uncheckedBounds: (5, data.count))
// let range = Range(uncheckedBounds: (5, data.count))
//let newData = data.subdata(in: range) /* subset response data! */

//    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()

