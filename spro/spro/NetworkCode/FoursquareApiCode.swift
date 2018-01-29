//
//  FoursquareApiCode.swift
//  spro
//
//  Contains methods that can be used in the view controllers to request data from the Foursquare API.
//
//  Created by Sam Kortekaas on 13/01/2018.
//  Student ID: 10718095
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import Foundation
import UIKit

// Set info for Foursquare API
let client_id = "LUQIERMX12DOLJDUO555MIABXXL1LXY3LB34V5BW0NGIEPEB"
let client_secret = "KCXATVV3JBEX10ND13JD1G0QF5FHTHXW4QOKRSFIMPRND44J"

class RequestController {
    
    // Shared static is used to share the requestController among viewcontrollers.
    static let shared = RequestController()
    
    // Get a list of search results from foursquare
    func getCoffeeBars(lat: Double, lon: Double, completion: @escaping ([JSON]) -> Void) {
        var coffeeBars = [JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/search/recommendations?ll=\(lat),\(lon)&v=20180113&limit=3&query=coffee&client_id=\(client_id)&client_secret=\(client_secret)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            do {
                // Temporarily store returned data
                let json = try JSON(data: data!)
                
                // Store data after 'results' in the data structure
                coffeeBars = json["response"]["group"]["results"].arrayValue
                completion(coffeeBars)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    // Get details about a venue from Foursquare
    func getDetails(venueId: String, completion: @escaping ([String: JSON]) -> Void) {
        var venueDetails = [String: JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/venues/\(venueId)?&v=20180113&client_id=\(client_id)&client_secret=\(client_secret)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            do {
                // Temporarily store returned data
                let json = try JSON(data: data!)
                
                // Store data after 'response' in the data structure
                venueDetails = json["response"].dictionaryValue
                completion(venueDetails)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    // Get reviews about a venue from Foursquare
    func getReviews(venueID: String, completion: @escaping ([JSON]) -> Void) {
        var venueTips = [JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/venues/\(venueID)/tips?&v=20180113&client_id=\(client_id)&client_secret=\(client_secret)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            do {
                // Temporarily store returned data
                let json = try JSON(data: data!)
                
                // Store data after 'items' in the data structure
                venueTips = json["response"]["tips"]["items"].arrayValue
                completion(venueTips)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    // Get image of a venue from Foursquare
    func getImage(suffix: String, completion: @escaping (UIImage?) -> Void) {
        var url = URL(string: "https://igx.4sqi.net/img/general/800x800")!
        
        // Append the suffix with image id
        url.appendPathComponent(suffix)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
