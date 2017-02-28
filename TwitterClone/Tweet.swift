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
    var profileImageUrl: URL?
    var username: String?
    var givenName: String?
    var retweeted: Bool = false
    var nameOfPersonRetweeted: String?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        var user = dictionary["user"] as! NSDictionary
        profileImageUrl = URL(string: user["profile_image_url_https"] as! String)!
        username = "actualUserName"
        givenName = user["name"] as! String
        if let retweetedStatus = dictionary["retweeted_status"] {
            retweeted = true
            nameOfPersonRetweeted = (retweetedStatus as! NSDictionary)[]
        }
        //nameOfPersonRetweeted = dictionary[""]
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
