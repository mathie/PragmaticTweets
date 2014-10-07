//
//  TwitterAPIRequest.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 07/10/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit
import Social
import Accounts

class TwitterAPIRequest: NSObject {
    func sendTwitterRequest(requestURL: NSURL!, params: Dictionary<String, String>, delegate: TwitterAPIRequestDelegate?) {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: {
            (Bool granted, NSError error) -> Void in
            if !granted {
                println("Account access not granted")
            } else {
                let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                if twitterAccounts.count == 0 {
                    println("No twitter accounts configured")
                } else {
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: params)
                    request.account = twitterAccounts[0] as ACAccount
                    request.performRequestWithHandler({
                        (NSData data, NSHTTPURLResponse urlResponse, NSError error) -> Void in
                        if delegate != nil {
                            delegate!.handleTwitterData(data, urlResponse: urlResponse, error: error, fromRequest: self)
                        }
                    })
                }
            }
        })
    }
}
