//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 24/09/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit
import Social
import Accounts

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_0_200x200.png")

public class RootViewController: UITableViewController, TwitterAPIRequestDelegate {

    var parsedTweets : Array <ParsedTweet> = [
        ParsedTweet(tweetIdString: "1", tweetText: "iOS SDK Development now in print. Swifth programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetIdString: "2", tweetText: "Math is cool", userName: "@redqueencoder", createdAt: "2014-08-16 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetIdString: "3", tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-07-31 16:44:30 EDT", userAvatarURL: defaultAvatarURL)
    ]

    public override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresher
    }

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]

        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        
        if let userAvatarURL = parsedTweet.userAvatarURL {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                () -> Void in

                if let avatarImageData = NSData(contentsOfURL: userAvatarURL) {
                    let avatarImage = UIImage(data: avatarImageData)

                    dispatch_async(dispatch_get_main_queue(), {
                        () -> Void in
                        if cell.userNameLabel.text == parsedTweet.userName {
                            cell.avatarImageView.image = avatarImage
                        } else {
                            println("Warning: avatar isn't for this username.")
                        }
                    })
                } else {
                    println("Warning: can't load avatar image")
                }
            })
        }
        
        return cell
    }

    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let message = NSBundle.mainBundle().localizedStringForKey("I just finished chapter 9 in iOS 8 SDK Development. #pragsios8", value: "", table: nil)
            tweetVC.setInitialText(message)
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            println("Can't send tweet")
        }
    }

    @IBAction func handleRefresh(sender : AnyObject?) {
        reloadTweets()
    }
    
    func reloadTweets() {
        let twitterParams = [
            "count": "100"
        ]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        
        let request = TwitterAPIRequest(requestURL: twitterAPIURL, params: twitterParams, delegate: self)
        request.sendTwitterRequest()
    }

    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let validData = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(validData, options: NSJSONReadingOptions(0), error: &parseError)

            if let jsonArray = jsonObject as? Array<Dictionary<String, AnyObject>> {
                self.parsedTweets.removeAll(keepCapacity: true)

                for tweetDict in jsonArray {
                    let parsedTweet = ParsedTweet()
                    parsedTweet.tweetIdString = tweetDict["id_str"] as String?
                    parsedTweet.tweetText = tweetDict["text"] as String?
                    parsedTweet.createdAt = tweetDict["created_at"] as String?
                    
                    let userDict = tweetDict["user"] as Dictionary<String, AnyObject>
                    parsedTweet.userName = userDict["name"] as String?
                    parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as String!)
                    
                    self.parsedTweets.append(parsedTweet)
                }

                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    self.tableView.reloadData()
                    if let refreshControl = self.refreshControl {
                        refreshControl.endRefreshing()
                    }
                })
            }
        } else {
            println("handleTwitterData received no data.")
        }
    }

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let tweetDetailViewController = segue.destinationViewController as? TweetDetailViewController {
                let row = self.tableView!.indexPathForSelectedRow()!.row
                let parsedTweet = parsedTweets[row] as ParsedTweet
                tweetDetailViewController.tweetIdString = parsedTweet.tweetIdString
            }
        }
    }
}

