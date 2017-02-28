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
    var id: String?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImageUrl: URL?
    var username: String?
    var givenName: String?
    var retweeted: Bool = false
    var nameOfPersonRetweeted: String?
    func initRetweet(main: NSDictionary, retweeted: NSDictionary){
        self.retweeted = true
        let user = main["user"] as! NSDictionary
        nameOfPersonRetweeted = user["name"] as? String
        text = main["text"] as? String
        let userOfRetweeted = retweeted["user"] as! NSDictionary
        profileImageUrl = URL(string: userOfRetweeted["profile_image_url_https"] as! String)!
        givenName = userOfRetweeted["name"] as? String
        username = userOfRetweeted["screen_name"] as? String
        retweetCount = retweeted["retweet_count"] as! Int
        favoritesCount = retweeted["favorite_count"] as! Int
        id = retweeted["id_str"] as? String
        
    }
    init(dictionary: NSDictionary){
        super.init()
        if let retweetedTweet = dictionary["retweeted_status"] as? NSDictionary {
            initRetweet(main: dictionary, retweeted: retweetedTweet)
        } else {
            text = dictionary["text"] as? String
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
            let user = dictionary["user"] as! NSDictionary
            profileImageUrl = URL(string: user["profile_image_url_https"] as! String)!
            username = user["screen_name"] as? String
            givenName = user["name"] as? String
            
            favoritesCount = dictionary["favorite_count"] as! Int
            retweetCount = dictionary["retweet_count"] as! Int
            id = dictionary["id_str"] as? String
            
            if let timeStampString = dictionary["created_at"] as? String{
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                timestamp = formatter.date(from: timeStampString)
                
            }
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
