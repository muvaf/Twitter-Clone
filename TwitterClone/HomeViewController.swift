//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, ProfileImageClickable {

    @IBOutlet weak var homeTable: UITableView!
    var tweets: [Tweet] = []
    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance.logout()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        homeTable.dataSource = self
        homeTable.rowHeight = UITableViewAutomaticDimension
        homeTable.estimatedRowHeight = 200.0
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.loadTweets(refreshControl:)), for: UIControlEvents.valueChanged)
        homeTable.insertSubview(refreshControl, at: 0)

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Tweet.TweetDataNotification), object: nil, queue: OperationQueue.main, using: {(notification: Notification) -> Void in
            self.homeTable.reloadData()
        })
        loadTweets(refreshControl: nil)
        
        
    }
    func profileImageClicked(recognizer: UITapGestureRecognizer){
        let cell = recognizer.view!.superview!.superview as! HomeTableViewCell        
        performSegue(withIdentifier: "profileImageSegue", sender: cell)
        
    }
    func loadTweets(refreshControl: UIRefreshControl?){
        TwitterClient.sharedInstance.fetchHomeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Tweet.TweetDataNotification), object: nil)
            if let control = refreshControl {
                control.endRefreshing()
            }
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tweets.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTable.dequeueReusableCell(withIdentifier: "HomeTableCellView") as! HomeTableViewCell
        cell.callerDelegate = self
        cell.initializeTweet(tweet: tweets[indexPath.row])
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? HomeTableViewCell, let indexPath = homeTable.indexPath(for: cell) {
            if (segue.identifier == "TweetCellSegue"){
                let tweetVC = segue.destination as! TweetVC
                tweetVC.tweet = tweets[indexPath.row]
                
            } else if segue.identifier == "profileImageSegue" {
                let profileVC = segue.destination as! ProfileVC
                profileVC.initialize(with: cell.tweet!.username!)
            }
        } else if segue.identifier == "MyProfileSegue" {
            let profileVC = segue.destination as! ProfileVC
            profileVC.initialize(with: User.currentUser!.screenName!)
        } else if segue.identifier == "ReplyComposeVCSegue" {
            let replyButton = sender as! UIButton
            if let cell = replyButton.superview?.superview?.superview as? HomeTableViewCell, let IndexPath = homeTable.indexPath(for: cell){
                let composeVC = segue.destination as! ComposeVC
                composeVC.replyTo = tweets[IndexPath.row]
            }
        }
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
