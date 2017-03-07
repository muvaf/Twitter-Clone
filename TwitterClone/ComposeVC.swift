//
//  ComposeVC.swift
//  TwitterClone
//
//  Created by monus on 3/7/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class ComposeVC: UIViewController, UITextViewDelegate {
    
    var replyTo: Tweet?

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBAction func sendTweetClicked(_ sender: UIBarButtonItem) {
        
            TwitterClient.sharedInstance.tweet(newTweet: tweetTextView.text, replyTweetId: replyTo?.id, success: { (dic: NSDictionary) in
                self.navigationController!.popViewController(animated: true)
            }, failure: { (err: Error) in
                print(err.localizedDescription)
            })

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        if let user = User.currentUser {
            profileImage.setImageWith(user.profileImageUrl!)
            nameLabel.text = user.name!
            usernameLabel.text = user.screenName!
        }
        tweetTextView.becomeFirstResponder()
        if let replyTo = replyTo {
            tweetTextView.text = "@" + replyTo.username! + " "
        }
        characterCountLabel.text = String(describing: 140-tweetTextView.text.characters.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = String(describing: 140-textView.text.characters.count)
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
