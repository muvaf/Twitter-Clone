//
//  Tweet.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    static let TweetDataNotification = "TweetDataLoaded"
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        if let timeStampString = dictionary["created_at"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStampString)
        }
    }
    
    class func tweets(from dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            tweets.append( Tweet(dictionary: dictionary) )
        }
        return tweets
    }

}
