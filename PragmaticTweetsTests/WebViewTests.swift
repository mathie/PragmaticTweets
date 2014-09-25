//
//  WebViewTests.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 24/09/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit
import XCTest
import PragmaticTweets

class WebViewTests: XCTestCase, UIWebViewDelegate {

    var loadedWebViewExpectation : XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAutomaticWebLoad() {
        if let viewController = UIApplication.sharedApplication().windows[0].rootViewController as? ViewController {
            let twitterWebView = viewController.twitterWebView
            twitterWebView.delegate = self
            self.loadedWebViewExpectation = expectationWithDescription("web view auto-load test")
            waitForExpectationsWithTimeout(5.0, handler: nil)
        } else {
            XCTFail("couldn't get root view controller")
        }
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        XCTFail("web view load failed")
        self.loadedWebViewExpectation!.fulfill()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        let webViewContents = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.textContent")
        
        XCTAssertNotNil(webViewContents, "web view contents are nil")
        if webViewContents! != "" {
            self.loadedWebViewExpectation!.fulfill()
        }

    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
