//
//  HomeTableViewCell.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetedImage: UIImageView!
    @IBOutlet weak var nameOfPersonRetweeted: UILabel!
    @IBOutlet weak var givenName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var hours: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func initializeTweet(tweet: Tweet){
        if (!tweet.retweeted){
            retweetedImage.isHidden = true
            nameOfPersonRetweeted.isHidden = true
        } else {
            nameOfPersonRetweeted.text = tweet.nameOfPersonRetweeted!
        }
        profileImage.setImageWith(tweet.profileImageUrl!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
