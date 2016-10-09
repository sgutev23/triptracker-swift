//
//  TripsTableViewController.swift
//  TripTracker
//
//  Created by Stan Gutev on 10/9/16.
//  Copyright © 2016 Stanislav Gutev. All rights reserved.
//

import UIKit

class TripsTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveTripCell", for: indexPath) as! ActiveTripTableViewCell
        
        cell.distance.text = "500 km"
        cell.date.text = "17/10/2016 10:30"
        cell.tripTitle.text = "Trip to Frankfurt"
        return cell
    }
}
