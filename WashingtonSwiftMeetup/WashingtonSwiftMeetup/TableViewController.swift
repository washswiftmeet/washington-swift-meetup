//
//  ViewController.swift
//  WashingtonSwiftMeetup
//
//  Created by Cameron Conway on 3/5/15.
//  Copyright (c) 2015 Cam-Built Programming Plus. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var entries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        entries.append("Entry 1")
        entries.append("Entry 2")
        entries.append("Entry 3")
        entries.append("Entry 4")
        entries.append("Entry 5")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    	return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "EntryCell")
        
        cell.textLabel?.text = entries[indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if entries[indexPath.row] == "Entry 3" {
            return 60
        } else {
            return 40
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("User just tapped on a row")
    }
    
    func lookupGoogle()
    {
        // Contents of json is in GoogleJSON in this project. This has been tested and will work with a valid Google API Key. 
        let GOOGLE_API_KEY = "<insert API Key>"
        let searchString = "Washington"
        var urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchString)&sensor=true&types=(cities)&key=\(GOOGLE_API_KEY)"
        let url:NSURL! = NSURL(string: urlString)
        
        if url != nil {
            let request = NSURLRequest(URL: url)
            var err:NSError?
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                if error == nil {
                    if var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error:&err) as? NSDictionary {
                        println(json)
                        for prediction in json["predictions"] as Array<NSDictionary> {
                            println(prediction["description"]!)
                        }
                    }
                }
            })
        }
    }

}

