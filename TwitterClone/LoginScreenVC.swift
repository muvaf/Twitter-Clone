//
//  LoginScreenVC.swift
//  TwitterClone
//
//  Created by monus on 2/21/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginScreenVC: UIViewController {

    @IBAction func onLoginButton(_ sender: UIButton) {
        // Do any additional setup after loading the view.
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "y4RuwSRLXByC3EFkuVmuMfpjo", consumerSecret: "nZ5EkRWylARHRzVno7psR8b0aZJKs4ysebKldOvruJvWa4Ls9l")
        
        twitterClient?.deauthorize()
        
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("Success!")
            
            let stringUrl = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)"
            let url = URL(string:stringUrl)!
            UIApplication.shared.open(url, options: [:], completionHandler: { (result: Bool) in
                print("yeah!")
            })
            
        }, failure: { (error: Error?) in
            print("ERROR: " + error!.localizedDescription)
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
