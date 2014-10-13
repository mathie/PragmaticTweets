//
//  UserDetailViewController.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 10/10/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, TwitterAPIRequestDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!

    var screenName: String?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadUserDetails()
    }
    
    func reloadUserDetails() {
        if screenName == nil {
            return
        }

        let twitterRequest = TwitterAPIRequest(
            requestURLFragment: "users/show",
            params: [ "screen_name": screenName! ],
            delegate: self)
        twitterRequest.sendTwitterRequest()
    }

    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let validData = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &parseError)
            if let errorValue = parseError {
                println("JSON parsing failed: \(errorValue).")
                return
            }
            
            if let userDict = jsonObject as? Dictionary<String, AnyObject> {
                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in

                    self.userRealNameLabel!.text = userDict["name"] as? String
                    self.userScreenNameLabel!.text = userDict["screen_name"] as? String
                    self.userLocationLabel.text = userDict["location"] as? String
                    self.userDescriptionLabel.text = userDict["description"] as? String
                    
                    let userImageURL = NSURL(string: userDict["profile_image_url"] as NSString!)!
                    self.userImageView.image = UIImage(data: NSData(contentsOfURL: userImageURL)!)
                })
            } else {
                println("handleTwitterData received no valid data.")
            }
        }
    }
    
    @IBAction func unwindToTweetDetailViewController(segue: UIStoryboardSegue?) {
    }
}
