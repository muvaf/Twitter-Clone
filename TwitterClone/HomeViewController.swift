//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {

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
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Tweet.TweetDataNotification), object: nil, queue: OperationQueue.main, using: {(notification: Notification) -> Void in
            self.homeTable.reloadData()
        })
    
        TwitterClient.sharedInstance.fetchHomeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Tweet.TweetDataNotification), object: nil)
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
        
        cell.tweetText.text = tweets[indexPath.row].text!
        
        return cell
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
