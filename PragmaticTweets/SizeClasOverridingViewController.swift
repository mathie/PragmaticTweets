//
//  SizeClasOverridingViewController.swift
//  PragmaticTweets
//
//  Created by Graeme Mathieson on 16/10/2014.
//  Copyright (c) 2014 Graeme Mathieson. All rights reserved.
//

import UIKit

class SizeClasOverridingViewController: UIViewController {
    
    var embeddedSplitViewController : UISplitViewController?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSplitViewSegue" {
            self.embeddedSplitViewController = segue.destinationViewController as? UISplitViewController
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("viewWillTransitionToSize: entered")
        if size.width > 480.0 {
            println("viewWillTransitionToSize: width > 480")
            let overrideTraits = UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
            self.setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitViewController!)
        } else {
            println("viewWillTransitionToSize: width <= 480")
            self.setOverrideTraitCollection(nil, forChildViewController: embeddedSplitViewController!)
        }
    }
}
