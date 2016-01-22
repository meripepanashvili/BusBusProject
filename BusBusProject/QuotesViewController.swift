//
//  QuotesViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 1/14/16.
//  Copyright © 2016 Nino Basilaia. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var misalmeba = ["გამარჯობა ლამაზო", "ოლაა", "ჰაი", "მუჭორექ", "პრივეტები", "რავა ხარ სიმოოონ", "გგ, როგორა ხარ", "ბჯ, რავა ხარ", "ოჯახში როგორ ხარ?", "ჯგირობუა სქანი"]
    var ragac = ["ტელეფონი დამიჯდა და მაინც გწერ", "ღორის გრიპი რო დადის გაიგე?", "პატიოსანი ბიჭი ვარ ძმიშვილს გეფიცები", "ჩემთან ადგილია გადმო", "გვერდზე სუნიანი კაცი მიზის"]
    var damshvidobeba = ["აბა ჰე", "აბა ჰო", "აბა ჰუ", "ჩკ", "გაკოცეე", "გამიხარდიიი", "ნომი დატოვე", "ძირაფაშახ", "ჯგირო ორდა", "გახარებული ვორექი სკან ძირაფათი"]
    var saubrisDawyeba = ["შენი სახელი მაჩუქე ლამაზო", "რომელი საათია?", "რა კაი ამინდია, არა?", "გოგო ხარ თუ ბიჭი?", "რომელ გაჩერებაზე ჩადიხარ?", "რამდენი წლის ხარ?", "მურჯოხო?"]
    var xotba = ["დიდი ხანია მიწაზე დაეცი?", "მიწაზე რომ დაეცი ფრთები ხომ არ იტკინე?", "შენნაირი სიმპათიური ბევრი ყავს დედაშენს?", "გოლვაფირო", "სკვამი რექი"]
    
    var category : String = ""
    var quotes = [String : [String]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quotes["მისალმება"] = misalmeba
        quotes["რაღაც"] = ragac
        quotes["დამშვიდობება"] = damshvidobeba
        quotes["ხოტბა"] = xotba
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
        cell.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        cell.textLabel?.numberOfLines = 2;
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
