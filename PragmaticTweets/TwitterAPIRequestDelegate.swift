//
//  TwitterAPIRequestDelegate.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 07/10/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import Foundation

protocol TwitterAPIRequestDelegate {
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!)
}