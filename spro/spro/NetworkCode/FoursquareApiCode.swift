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
let client_id = "HMRVEYYTHYZNXSVZ31DOI1F3QFZEGPL34ULO2UWZNV0ZOWNJ"
let client_secret = "4HBTUH4GO0AWNX0MWGPJH0MUVLTXGFMAU1BS3FRM5NBDR4HD"

class RequestController {
    
    // Shared static is used to share the requestController among viewcontrollers.
    static let shared = RequestController()
    
    
    func getCoffeeBars(lat: Double, lon: Double, completion: @escaping ([JSON]) -> Void) {
        var coffeeBars = [JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/search/recommendations?ll=\(lat),\(lon)&v=20180113&limit=3&query=specialty+coffee&client_id=\(client_id)&client_secret=\(client_secret)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            if let data = data {
                let json = JSON(data: data)
                coffeeBars = json["response"]["group"]["results"].arrayValue
                completion(coffeeBars)
            } else {
                print("Error getting data from API")
            }
        })
        task.resume()
    }
    
    func getDetails(venueId: String, completion: @escaping ([String: JSON]) -> Void) {
        var venueDetails = [String: JSON]()
        let url = URL(string: "https://api.foursquare.com/v2/venues/\(venueId)?&v=20180113&client_id=\(client_id)&client_secret=\(client_secret)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            if let data = data {
                let json = JSON(data: data)
                venueDetails = json["response"].dictionaryValue
                completion(venueDetails)
            } else {
                print("Error getting data from API")
            }
        })
        task.resume()
    }
    
    func getImage(suffix: String, completion: @escaping (UIImage?) -> Void) {
        var url = URL(string: "https://igx.4sqi.net/img/general/500x500")!
        
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
