//
//  HomeTableViewCell.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import DateToolsSwift

@objc
protocol ProfileImageClickable {
    // protocol definition goes here
    func profileImageClicked(recognizer: UITapGestureRecognizer)
}


class HomeTableViewCell: UITableViewCell {

    @IBAction func retweetClicked(_ sender: UIButton) {
        if !retweeted {
            setRetweetCount(count: tweet!.retweetCount + 1)
            retweeted = true
        } else {
            setRetweetCount(count: tweet!.retweetCount - 1)
        }
    }
    @IBAction func favorClicked(_ sender: UIButton) {
        if !favored {
            setFavorCount(count: tweet!.favoritesCount + 1)
            favored = true
        } else {
            setFavorCount(count: tweet!.favoritesCount - 1)
            
        }
    }

    var favored: Bool = false
    var retweeted: Bool = false
    @IBOutlet weak var favorCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var retweetedImage: UIImageView!
    @IBOutlet weak var nameOfPersonRetweeted: UILabel!
    @IBOutlet weak var givenName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var callerDelegate: ProfileImageClickable?
    
    var tweet: Tweet?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    func setRetweetCount (count: Int){
        if tweet!.retweetCount < count {
            TwitterClient.sharedInstance.retweet(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                let newTweet = Tweet(dictionary: newDict)
                self.initializeTweet(tweet: newTweet)
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.unretweet(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                let newTweet = Tweet(dictionary: newDict)
                self.initializeTweet(tweet: newTweet)
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        }
        tweet!.retweetCount = count
        retweetCount.text = String(describing: tweet!.retweetCount)
        if tweet!.retweetCount > 0 {
            retweetCount.isHidden = false
        }
        
    }
    func setFavorCount (count: Int){
        if tweet!.favoritesCount < count {
            TwitterClient.sharedInstance.favor(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                let newTweet = Tweet(dictionary: newDict)
                self.initializeTweet(tweet: newTweet)
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.unfavor(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                let newTweet = Tweet(dictionary: newDict)
                self.initializeTweet(tweet: newTweet)
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        }
        tweet!.favoritesCount = count
        favorCount.text = String(describing: tweet!.favoritesCount)
        if tweet!.favoritesCount > 0 {
            favorCount.isHidden = false
        }
        
    }
    
    func initializeTweet(tweet: Tweet){
        self.tweet = tweet
        if (tweet.retweeted){
            nameOfPersonRetweeted.text = tweet.nameOfPersonRetweeted! + " retweeted"
        } else {
            retweetedImage.isHidden = true
            nameOfPersonRetweeted.isHidden = true
        }
        if let time = tweet.timestamp {
            hours.text = time.shortTimeAgoSinceNow
        }
        if tweet.favoritesCount == 0 {
            favorCount.isHidden = true
        } else {
            favorCount.text = String(describing: tweet.favoritesCount)
        }
        
        if tweet.retweetCount == 0 {
            retweetCount.isHidden = true
        } else {
            retweetCount.text = String(describing: tweet.retweetCount)
        }
        username.text = "@" + tweet.username!
        givenName.text = tweet.givenName!
        tweetText.text = tweet.text!
        profileImage.setImageWith(tweet.profileImageUrl!)
        if let delegate = callerDelegate {
            let gesture = UITapGestureRecognizer(target: delegate, action: #selector(ProfileImageClickable.profileImageClicked(recognizer:)))
            profileImage.addGestureRecognizer(gesture)
        }
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
