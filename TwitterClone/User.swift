//
//  User.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageUrl: URL?
    var tagLine: String?
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        if let profileImageUrlString = dictionary["profile_image_url_https"] as? String {
            profileImageUrl = URL(string: profileImageUrlString)!
        }
        tagLine = dictionary["description"] as? String
    }

}
