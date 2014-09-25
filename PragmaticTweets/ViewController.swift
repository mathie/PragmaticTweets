//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 24/09/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit
import Social

public class ViewController: UIViewController {

    @IBOutlet public weak var twitterWebView: UIWebView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTweets()
    }

    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let message = NSBundle.mainBundle().localizedStringForKey("I just finished the first project in iOS 8 SDK Development. #pragsios8", value: "", table: nil)
            tweetVC.setInitialText(message)
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            println("Can't send tweet")
        }
    }

    @IBAction func handleShowMyTweetsButtonTapped(sender: UIButton) {
        self.reloadTweets()
    }

    func reloadTweets() {
        let url = NSURL(string: "https://twitter.com/mathie")
        let urlRequest = NSURLRequest(URL: url)
        self.twitterWebView.loadRequest(urlRequest)
    }
}

