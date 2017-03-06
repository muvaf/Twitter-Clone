//
//  TweetVC.swift
//  TwitterClone
//
//  Created by monus on 3/6/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import DateToolsSwift

class TweetVC: UIViewController {
    
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
            //TODO: unretweet
        } else {
            setRetweetCount(count: tweet!.retweetCount + 1)
        }
        
    }
    @IBAction func replyButtonClicked(_ sender: UIButton) {
    }
    @IBAction func favorButtonClicked(_ sender: UIButton) {
        if favorited {
            
        } else {
            setFavorCount(count: tweet!.favoritesCount+1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let tweet = tweet {
            tweetText.text = tweet.text!
            fullnameText.text = tweet.givenName!
            usernameText.text = "@" + tweet.username!
            profileImage.setImageWith(tweet.profileImageUrl!)
            retweetNumberText.text = String(describing: tweet.retweetCount)
            starsNumberText.text = String(describing: tweet.favoritesCount)
            dateText.text = tweet.timestamp!.format(with: "d/M/yy, HH:mm a")
            
            
            if tweet.retweeted {
                whoRetweetedText.text = tweet.nameOfPersonRetweeted! + " retweeted"
                whoRetweetedText.isHidden = false
                retweetedIcon.isHidden = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setRetweetCount (count: Int){
        TwitterClient.sharedInstance.retweet(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
            self.tweet = Tweet(dictionary: newDict)
            self.retweetNumberText.text = String(describing: self.tweet!.retweetCount)
        }, failure: {(error: Error) -> Void in
            print(error.localizedDescription)
        })
    }
    func setFavorCount (count: Int){
        TwitterClient.sharedInstance.favor(tweet: self.tweet!, success: { (newDict: NSDictionary) -> Void in
            self.tweet = Tweet(dictionary: newDict)
            self.starsNumberText.text = String(describing: self.tweet!.favoritesCount)
        }, failure: {(error: Error) -> Void in
            print(error.localizedDescription)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
