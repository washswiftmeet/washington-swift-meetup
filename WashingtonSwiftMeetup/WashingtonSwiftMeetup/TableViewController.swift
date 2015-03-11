//
//  TableViewController.swift
//  WashingtonSwiftMeetup
//
//  Created by Cameron Conway on 3/5/15.
//  Copyright (c) 2015 Cam-Built Programming Plus. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UITableViewController {
    var entries = [String]()
//    var detailViewController:DetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        entries.append("Entry 1")
        entries.append("Entry 2")
        entries.append("Entry 3")
        entries.append("Entry 4")
        entries.append("Entry 5")
        
//        detailViewController = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? splitViewController!.viewControllers[1] as DetailViewController : tabBarController!.viewControllers?[2] as DetailViewController
    }

//    This func will go in DetailViewController.
//
//    func loadForm(entry:[String:AnyObject?])
//    {
//        
//    }
    
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
    
    func searchFourSquare()
    {
        let mapView = MKMapView() // This mapView will eventually be in the detail pane. 
        let distance = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta, longitudeDelta: mapView.region.span.longitudeDelta).latitudeDelta
        let centerLatitude = mapView.region.center.latitude; let centerLongitude = mapView.region.center.longitude
        var term = "restaurant"
        
        let clientID = "<FourSquare Client ID>"
        let clientSecret = "<FourSquare Secret>"
        let urlString = "https://api.foursquare.com/v2/venues/explore?query=\(term)&ll=\(centerLatitude),\(centerLongitude)&client_id=\(clientID)&client_secret=\(clientSecret)&intent=browse&radius=800&v=20150225";
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if error == nil {
                var err:NSError?
                let httpResponse = response as NSHTTPURLResponse!
                
                if httpResponse.statusCode == 200 {
                    if var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error:&err) as? NSDictionary {
                        if var response = json.valueForKey("response") as? NSDictionary {
                            if var groups = response.valueForKey("groups") as? [NSDictionary] {
                                for group in groups as [NSDictionary] {
                                    if var items = group.valueForKey("items") as? [NSDictionary] {
                                        for item in items as [NSDictionary] {
                                            if var venue = item.valueForKey("venue") as? NSDictionary {
                                                println(venue.valueForKey("name")!)
                                                if var price = venue.valueForKey("price") as? NSDictionary {
                                                    println(price.valueForKey("tier")!)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }

}

