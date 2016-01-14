//
//  QuotesViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 1/14/16.
//  Copyright © 2016 Nino Basilaia. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var misalmeba = ["გამარჯობა 'ლ'ამაზო", "ოლაა", "პრივეტ", "ჩკ", "რავა ხარ სიმოოონ"]
    var ragac = ["რაღაც", "რაღაც", "რაღაც", "რაღაც", "რაღაც"]
    var damshvidobeba = ["აბა ჰე", "აბა ჰო", "აბა ჰუ"]
    var kideRagac = ["კიდე რაღაც", "კიდე რაღაც", "კიდე რაღაც", "კიდე რაღაც", "კიდე რაღაც"]
    var saubrisDawyeba = ["შენი სახელი მაჩუქე ლამაზო"]
    
    var category : String = ""
    var quotes = [String : [String]]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quotes["მისალმება"] = misalmeba
        quotes["რაღაც"] = ragac
        quotes["დამშვიდობება"] = damshvidobeba
        quotes["კიდე რაღაც"] = kideRagac
        quotes["საუბრის დაწყება"] = saubrisDawyeba
        
        tableView.delegate = self
        tableView?.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes[category]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Quote", forIndexPath: indexPath)

        var quotes = [String]()
        quotes = self.quotes[category]!
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = quote
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier where id == "chose" {
            if let toViewController = segue.destinationViewController as? CategoriesViewController {
                if let cell = sender as? UITableViewCell {
                    toViewController.quote = (cell.textLabel?.text)!
                }
            }
        }
    }

}
