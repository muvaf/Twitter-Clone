//
//  User.swift
//  TwitterClone
//
//  Created by monus on 2/24/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class User: NSObject {
    
    static let userDidLogoutNotification = "UserDidLogout"
    var name: String?
    var screenName: String?
    var profileImageUrl: URL?
    var tagLine: String?
    
    var userData: NSDictionary?
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let data = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: data)
                }
            }
            return _currentUser
        }
        set (user){
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.userData!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
                
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    init(dictionary: NSDictionary){
        userData = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String

        
        if let profileImageUrlString = dictionary["profile_image_url_https"] as? String {
            profileImageUrl = URL(string: profileImageUrlString)!
        }
        tagLine = dictionary["description"] as? String
    }

}
