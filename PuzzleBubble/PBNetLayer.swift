//
//  PBNetLayer.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 11/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation

// This class provides an api layer for performing http requests to Parse
class PBNetLayer: NSObject {
  
  var session: NSURLSession
  
  /// Initialise the Network Layer
  override init() {
    session = NSURLSession.sharedSession()
  }
  
  /// Convert a blob of binary json to ascii encoded json
  /// Note: this block of code is found in the "Movie Manager" presented as
  ///       a part of the iOS Networking Udacity Course
  class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
  
    /// Try to parse the data as JSON
    do {
      let parsedResult: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
      
      /// Successfully parsed the JSON
      completionHandler(result: parsedResult, error: nil)
    } catch {
      /// There was an error parsing the JSON
      let userInfo = [NSLocalizedDescriptionKey : "Failed to parse JSON)"]
      let parseError =  NSError(domain: "PB Network Layer Error", code: 1, userInfo: userInfo)
      completionHandler(result: nil, error: parseError)
    }
  }
  
  /// Perform a HTTP Get request to the specified URL, method and parameters
  func doParseGetReq(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> Bool {
    
    /// Set the parse URL - of form https://api.parse.com/1/classes/<method>
    let fullUrl: NSURL = NSURL(string: "\(PBClient.Constants.ParseBaseURL)/\(method)")!
    
    /// create the URL request and set the http parameters
    let request = NSMutableURLRequest(URL: fullUrl)
    request.HTTPMethod = "GET"
    
    /// Set the App ID and the REST API Key for the request to the parse service
    request.addValue(PBClient.Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(PBClient.Constants.ParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    /// perform the GET request - this is an asyncronous call.
    /// Call the completion handler once returned.
    let task = self.session.dataTaskWithRequest(request) { data, response, error in
      if let _ = error {
        /// There was an error so return as such
        let userInfo = [NSLocalizedDescriptionKey : "Failed to GET Parse data @ \(fullUrl.absoluteString)"]
        let getError =  NSError(domain: "PBClient Error", code: 1, userInfo: userInfo)
        completionHandler(result: nil, error: getError)
      } else {
        /// Parse the data to JSON
        PBNetLayer.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
      }
    }
    task.resume()
    return true
  }
}