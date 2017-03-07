//
//  TwitterClient.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "y4RuwSRLXByC3EFkuVmuMfpjo", consumerSecret: "nZ5EkRWylARHRzVno7psR8b0aZJKs4ysebKldOvruJvWa4Ls9l")!
    
    var loginSuccess: ( ()->() )?
    var loginFailure: ( (Error)->() )?
    
    func retweet(tweet: Tweet, success: @escaping (NSDictionary)->(), failure: @escaping (Error)->()){
        let dict = ["id": tweet.id!]
        print("1.1/statuses/retweet/" + tweet.id! + ".json")
        post("1.1/statuses/retweet/" + tweet.id! + ".json", parameters: dict, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success(response as! NSDictionary)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func unretweet(tweet: Tweet, success: @escaping (NSDictionary)->(), failure: @escaping (Error)->()){
        let dict = ["id": tweet.id!]
        post("1.1/statuses/unretweet/" + tweet.id! + ".json", parameters: dict, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success(response as! NSDictionary)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func favor(tweet: Tweet, success: @escaping (NSDictionary)->(), failure: @escaping (Error)->()){
        let dict = ["id": tweet.id!]
        post("1.1/favorites/create.json?id=" + tweet.id!, parameters: dict, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success(response as! NSDictionary)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func unfavor(tweet: Tweet, success: @escaping (NSDictionary)->(), failure: @escaping (Error)->()){
        let dict = ["id": tweet.id!]
        post("1.1/favorites/destroy.json?id=" + tweet.id!, parameters: dict, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success(response as! NSDictionary)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func tweet(newTweet: String, replyTweetId: String?, success: @escaping (NSDictionary)->(), failure: @escaping (Error)->()){
        let dict = NSMutableDictionary()
        dict["status"] = newTweet
        if let replyTweetId = replyTweetId {
            dict["in_reply_to_status_id"] = replyTweetId
        }
        post("1.1/statuses/update.json", parameters: dict, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success(response as! NSDictionary)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func login(success: @escaping ()->(), failure: @escaping (Error)->()){
        loginSuccess = success
        loginFailure = failure
        //deauthorize()
            fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twittorella://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
                print("Success!")
                let stringUrl = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)"
                let url = URL(string:stringUrl)!
                UIApplication.shared.open(url, options: [:], completionHandler: { (result: Bool) in
                    print("yeah!")
                })
                
            }, failure: { (error: Error?) in
                self.loginFailure?(error!)
            })
        
        
    }
    func openUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (credential: BDBOAuth1Credential?) in
            let success = TwitterClient.sharedInstance.requestSerializer.saveAccessToken(credential)
            
            if (success) {
                print("token saved")
            }
            self.fetchAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
        })
    }
    func logout(){
        User.currentUser = nil
        deauthorize()
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    func fetchHomeTimeline(success: @escaping ([Tweet])-> (), failure: @escaping (Error)->()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweets(from: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func fetchUserProfileTweets(of username: String, success: @escaping ([Tweet])-> (), failure: @escaping (Error)->()) {
        let parameters = ["screen_name": username]
        get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweets(from: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func fetchUser(with username: String, success: @escaping (User)->(), failure: @escaping (Error)->() ) {
        let parameters = ["screen_name":username]
        get("1.1/users/show.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let res = response as! NSDictionary
            
            let user = User(dictionary: res)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    func fetchAccount(success: @escaping (User)->(), failure: @escaping (Error)->() ) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let res = response as! NSDictionary
            
            let user = User(dictionary: res)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

}
