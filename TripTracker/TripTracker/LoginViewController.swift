//
//  LoginViewController.swift
//  TripTracker
//
//  Created by Stan Gutev on 10/8/16.
//  Copyright © 2016 Stanislav Gutev. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var rootRef = FIRDatabaseReference()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signIn(_ sender: AnyObject) {
        let user: String = username.text!
        let pwd: String = password.text!
        NSLog("Signing in \(user) + \(pwd)")
        FIRAuth.auth()?.signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            if error == nil {
                NSLog("Success")
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoggedIn")
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
            } else {
                print(error)
            }
        }
    }
    
    
    @IBAction func signUp(_ sender: AnyObject) {
        let user: String = username.text!
        let pwd: String = password.text!
        NSLog("Signing up \(user) + \(pwd)")
        FIRAuth.auth()?.createUser(withEmail: user, password: pwd) { (user, error) in
            if error == nil {
                NSLog("Success")
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoggedIn")
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
            } else {
                print(error)
            }
        }

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
