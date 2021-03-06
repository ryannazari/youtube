//
//  APIServices.swift
//  youtube
//
//  Created by Ryan Nazari on 3/11/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import UIKit

class APIServices: NSObject {
    
    static let sharedInstance = APIServices()
    
    let baseUrl = NSURL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets")!
    
    func fetchVideo(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let url = NSURL(string: urlString )
        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            if error != nil {
                print("there is error to fetching data\(String(describing: error))")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                for dictionary in json as! [[String: AnyObject]]{
                    
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    video.channel = channel
                    
                    videos.append(video)
                }
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }

}
