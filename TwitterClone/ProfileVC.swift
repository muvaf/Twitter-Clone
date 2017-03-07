//
//  ProfileVC.swift
//  TwitterClone
//
//  Created by monus on 3/6/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDataSource {


    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var givenName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet] = []
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tweetsTableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProfileVC.loadTweets(refresher:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(with username: String){
        TwitterClient.sharedInstance.fetchUser(with: username, success: { (user: User) in
            self.user = user
            self.initialize()
        }) { (err: Error) in
            print(err.localizedDescription)
        }
    }
    
    func initialize(){
        if let user = user {
            profileImage.setImageWith(user.profileImageUrl!)
            backgroundImage.setImageWith(user.backgroundImageUrl!)
            givenName.text = user.name!
            username.text = "@" + user.screenName!
            
            tweetCount.text = String(describing: user.tweetCount)
            followingCount.text = String(describing: user.followingCount)
            followerCount.text = String(describing: user.followerCount)
            
            loadTweets(refresher: nil)
            if User.currentUser!.screenName! != user.screenName! {
                composeButton.isEnabled = false
            }
        }
        
        
    }
    
    func loadTweets(refresher: UIRefreshControl?){
        TwitterClient.sharedInstance.fetchUserProfileTweets(of: user!.screenName!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            DispatchQueue.main.async() { () -> Void in
                self.tweetsTableView.reloadData()
                if let refresher = refresher {
                    refresher.endRefreshing()
                }
                
            }
        }, failure: {(err: Error) in
            print(err.localizedDescription)
        })
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tweets.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "HomeTableCellView") as! HomeTableViewCell
        cell.initializeTweet(tweet: tweets[indexPath.row])
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? HomeTableViewCell, let indexPath = tweetsTableView.indexPath(for: cell) {
            if (segue.identifier == "TweetCellSegueFromProfile"){
                let tweetVC = segue.destination as! TweetVC
                tweetVC.tweet = tweets[indexPath.row]
            }
        } else if segue.identifier == "ReplyComposeVCSegue", let composeVC = segue.destination as? ComposeVC {
            let replyButton = sender as! UIButton
            if let cell = replyButton.superview?.superview?.superview as? HomeTableViewCell, let indexPath = tweetsTableView.indexPath(for: cell) {
                composeVC.replyTo = tweets[indexPath.row]
            }
        }
    }
 

}
