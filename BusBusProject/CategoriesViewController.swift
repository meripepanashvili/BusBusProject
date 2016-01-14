//
//  CategoriesViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 1/14/16.
//  Copyright © 2016 Nino Basilaia. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    let transitionManager = TransitionManager()
    var quote : String = ""
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let toViewController = segue.destinationViewController as? QuotesViewController {
            toViewController.transitioningDelegate = self.transitionManager
            if let button = sender as? UIButton{
                toViewController.category = (button.titleLabel?.text)!
            }
        }
        if let id = segue.identifier where id == "backToChat" {
            if let toViewController = segue.destinationViewController as? ChatViewController {
                toViewController.transitioningDelegate = self.transitionManager
                toViewController.messageField.text = quote
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cooseCategory(sender: UIButton) {
        performSegueWithIdentifier("chooseCategory", sender: sender)
    }
    
    @IBAction func unwindToViewController2 (sender: UIStoryboardSegue){
        performSegueWithIdentifier("backToChat", sender: nil)
    }

}
