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

public class ViewController: UITableViewController {

    var parsedTweets : Array <ParsedTweet> = [
        ParsedTweet(tweetText: "iOS SDK Development now in print. Swifth programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencoder", createdAt: "2014-08-16 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-07-31 16:44:30 EDT", userAvatarURL: defaultAvatarURL)
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

        cell.userNameLabel!.text = parsedTweet.userName
        cell.tweetTextLabel!.text = parsedTweet.tweetText
        cell.createdAtLabel!.text = parsedTweet.createdAt
        
        if parsedTweet.userAvatarURL != nil {
            cell.avatarImageView!.image = UIImage(data: NSData(contentsOfURL: parsedTweet.userAvatarURL!)!)
        }
        
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

    @IBAction func handleRefresh(sender : AnyObject?) {
        self.parsedTweets.append(
            ParsedTweet(tweetText: "New row", userName: "@refresh", createdAt: NSDate().description, userAvatarURL: defaultAvatarURL)
        )
        reloadTweets()
        refreshControl!.endRefreshing()
    }
    
    func reloadTweets() {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
        if(twitterAccounts.count == 0) {
            println("No twitter accounts configured.")
            return
        }

        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: {
            (Bool granted, NSError error) -> Void in
            if(!granted) {
                println("Account access not granted.")
            } else {
                println("Account access granted.")
                
                let twitterParams = [
                    "count": "100"
                ]
                let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: twitterAPIURL, parameters: twitterParams)
                request.account = twitterAccounts[0] as ACAccount
                request.performRequestWithHandler({
                    (NSData data, NSHTTPURLResponse urlResponse, NSError error) -> Void in
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
            }
        })

        self.tableView.reloadData()
    }

    func handleTwitterData(data: NSData!, urlResponse: NSURLResponse!, error: NSError!) {
        if let validData = data {
            println("Valid twitter data: \(validData.length)")
        } else {
            println("handleTwitterData received no data.")
        }
    }
}

