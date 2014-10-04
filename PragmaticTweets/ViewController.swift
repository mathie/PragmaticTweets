//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 24/09/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit
import Social

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_0_200x200.png")

public class ViewController: UITableViewController {

    var parsedTweets : Array <ParsedTweet> = [
        ParsedTweet(tweetText: "iOS SDK Development now in print. Swifth programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencoder", createdAt: "2014-08-16 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-07-31 16:44:30 EDT", userAvatarURL: defaultAvatarURL)
    ]

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)!
        let parsedTweet = parsedTweets[indexPath.row]
        cell.textLabel!.text = parsedTweet.tweetText
        
        return cell
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
}

