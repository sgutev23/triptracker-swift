//
//  ViewController.swift
//  TripTracker
//
//  Created by Stan Gutev on 10/8/16.
//  Copyright © 2016 Stanislav Gutev. All rights reserved.
//

import UIKit
import Firebase

class TripsViewController: UIViewController {
    
    var newTripTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logOut(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotLoggedIn")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }

    
    @IBAction func addTrip(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Add a trip", message: nil, preferredStyle: .alert)
        
        // Add the text field for text entry.
        alertController.addTextField { textField in
            // If you need to customize the text field, you can do so here.
        }
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            NSLog("Cancelled")
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let title = alertController.textFields?[0].text!
            NSLog("Added \(title) ")
            self.newTripTitle = title!
            self.performSegue(withIdentifier: "ShowTripSegue", sender: nil)
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTripSegue" {
            if let destinationVC = segue.destination as? AddTripViewController {
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                backItem.tintColor = UIColor(red: 240/255, green: 95/255, blue: 65/255, alpha: 1)
                navigationItem.backBarButtonItem = backItem
                destinationVC.tripTitle = newTripTitle
            }
        }
    }
}

