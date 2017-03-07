//
//  TweetVC.swift
//  TwitterClone
//
//  Created by monus on 3/6/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import DateToolsSwift

class TweetVC: UIViewController, ProfileImageClickable {
    
    var tweet: Tweet?
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var fullnameText: UILabel!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var whoRetweetedText: UILabel!
    @IBOutlet weak var retweetedIcon: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetNumberText: UILabel!
    @IBOutlet weak var starsNumberText: UILabel!
    
    
    var retweeted: Bool = false
    var favorited: Bool = false
    @IBAction func retweetButtonClicked(_ sender: UIButton) {
        if retweeted {
            setRetweetCount(count: tweet!.retweetCount - 1)
        } else {
            setRetweetCount(count: tweet!.retweetCount + 1)
            retweeted = true
        }
        
    }
    @IBAction func replyButtonClicked(_ sender: UIButton) {
    }
    @IBAction func favorButtonClicked(_ sender: UIButton) {
        if favorited {
            setFavorCount(count: tweet!.favoritesCount-1)
        } else {
            favorited = true
            setFavorCount(count: tweet!.favoritesCount+1)
        }
    }
    func initializeTweet(){
        if let tweet = tweet {
            tweetText.text = tweet.text!
            fullnameText.text = tweet.givenName!
            usernameText.text = "@" + tweet.username!
            profileImage.setImageWith(tweet.profileImageUrl!)
            retweetNumberText.text = String(describing: tweet.retweetCount)
            starsNumberText.text = String(describing: tweet.favoritesCount)
            dateText.text = tweet.timestamp!.format(with: "d/M/yy, HH:mm a")
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ProfileImageClickable.profileImageClicked(recognizer:)))
            profileImage.addGestureRecognizer(gesture)
            
            if tweet.retweeted {
                whoRetweetedText.text = tweet.nameOfPersonRetweeted! + " retweeted"
                whoRetweetedText.isHidden = false
                retweetedIcon.isHidden = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeTweet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setRetweetCount (count: Int){
        if tweet!.retweetCount < count {
            TwitterClient.sharedInstance.retweet(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                self.tweet = Tweet(dictionary: newDict)
                self.initializeTweet()
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.unretweet(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                self.tweet = Tweet(dictionary: newDict)
                self.initializeTweet()
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        }
        tweet!.retweetCount = count
        retweetNumberText.text = String(describing: tweet!.retweetCount)
        
    }
    func setFavorCount (count: Int){
        if tweet!.favoritesCount < count {
            TwitterClient.sharedInstance.favor(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                self.tweet = Tweet(dictionary: newDict)
                self.initializeTweet()
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.unfavor(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
                self.tweet = Tweet(dictionary: newDict)
                self.initializeTweet()
            }, failure: {(error: Error) -> Void in
                print(error.localizedDescription)
            })
        }
        tweet!.favoritesCount = count
        starsNumberText.text = String(describing: tweet!.favoritesCount)
        
    }
    func profileImageClicked(recognizer: UITapGestureRecognizer){
        performSegue(withIdentifier: "profileImageSegueFromTweet", sender: tweet!)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ProfileVC, let tweet = sender as? Tweet {
            dest.initialize(with: tweet.username!)
        }
    }
 

}
