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
       
        TwitterClient.sharedInstance.login(success: { 
            print("LOGGED IN!")
        }, failure:{ (error: Error) -> Void in
            print(error.localizedDescription)
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
