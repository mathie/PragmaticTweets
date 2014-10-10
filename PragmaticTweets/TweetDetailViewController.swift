//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 10/10/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit
import MapKit

class TweetDetailViewController: UIViewController, TwitterAPIRequestDelegate {
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetLocationMapView: MKMapView!
    
    var tweetIdString : String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTweetDetails()
    }

    func reloadTweetDetails() {
        println("Reloading tweet id: \(tweetIdString)")

        if tweetIdString == nil {
            return
        }
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = [
            "id": tweetIdString!
        ]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json")
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let validData = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &parseError)
            if let errorValue = parseError {
                println("JSON parsing failed: \(errorValue).")
                return
            }
            
            if let tweetDict = jsonObject as? Dictionary<String, AnyObject> {
                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    
                    let userDict = tweetDict["user"] as Dictionary<String, AnyObject>

                    self.userRealNameLabel!.text = userDict["name"] as? String
                    self.userScreenNameLabel!.text = userDict["screen_name"] as? String
                    self.tweetTextLabel!.text = tweetDict["text"] as? String
                    
                    let userImageURL = NSURL(string: userDict["profile_image_url"] as NSString!)!
                    self.userImageButton.setTitle(nil, forState: UIControlState.Normal)
                    self.userImageButton.setImage(UIImage(data: NSData(contentsOfURL: userImageURL)!), forState: UIControlState.Normal)
                })
            } else {
                println("handleTwitterData received no valid data.")
            }
        }
    }
}
