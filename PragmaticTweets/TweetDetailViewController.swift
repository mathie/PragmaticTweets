//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 10/10/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    var tweetIdString : String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    func reloadTweetDetails() {
        println("Showing tweet id: \(tweetIdString)")
    }
}
