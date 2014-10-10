//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 04/10/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit

class ParsedTweet: NSObject {
    var tweetIdString : String?
    var tweetText : String?
    var userName : String?
    var createdAt : String?
    var userAvatarURL : NSURL?
    
    override init() {
        super.init()
    }

    init(tweetIdString: String?,
        tweetText: String?,
        userName: String?,
        createdAt: String?,
        userAvatarURL: NSURL?) {
            super.init()

            self.tweetIdString = tweetIdString
            self.tweetText = tweetText
            self.userName = userName
            self.createdAt = createdAt
            self.userAvatarURL = userAvatarURL
    }
}
