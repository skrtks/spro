//
//  FoursquareApiCode.swift
//  spro
//
//  Created by Sam Kortekaas on 13/01/2018.
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
    
    
    func getCoffeeBars(lat: Double, lon: Double, completion: @escaping ([JSON]) -> Void) {
        var coffeeBars = [JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/search/recommendations?ll=\(lat),\(lon)&v=20180113&limit=3&query=coffee&client_id=\(client_id)&client_secret=\(client_secret)")!
        print(url)
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            do {
                let json = try JSON(data: data!)
                coffeeBars = json["response"]["group"]["results"].arrayValue
                completion(coffeeBars)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func getDetails(venueId: String, completion: @escaping ([String: JSON]) -> Void) {
        var venueDetails = [String: JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/venues/\(venueId)?&v=20180113&client_id=\(client_id)&client_secret=\(client_secret)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            do {
                let json = try JSON(data: data!)
                venueDetails = json["response"].dictionaryValue
                completion(venueDetails)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func getReviews(venueID: String, completion: @escaping ([JSON]) -> Void) {
        var venueTips = [JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/venues/\(venueID)/tips?&v=20180113&client_id=\(client_id)&client_secret=\(client_secret)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            do {
                let json = try JSON(data: data!)
                venueTips = json["response"]["tips"]["items"].arrayValue
                
                completion(venueTips)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func getImage(suffix: String, completion: @escaping (UIImage?) -> Void) {
        var url = URL(string: "https://igx.4sqi.net/img/general/800x800")!
        
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
