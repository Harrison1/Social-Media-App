//
//  LoginViewController.swift
//  U Chatter
//
//  Created by Harrison McGuire on 12/3/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    //manual view controller variable
    let viewControllerRR:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavTime") as UIViewController
    
    //sign up button function that logs in the user
    @IBAction func loginButton(sender: AnyObject) {
        var chatter:PFUser = PFUser()
        chatter.username = self.username.text
        chatter.password = self.password.text
        
        PFUser.logInWithUsernameInBackground(chatter.username, password: chatter.password) {
            (user:PFUser!, error:NSError!)->Void in
            if user != nil {
                println("Login successfull")
                self.presentViewController(self.viewControllerRR, animated: true, completion: nil)
            } else {
                println("login failed")
                self.showAlert()
               
            }
        }
        
    }
    
    //function to show alert view that login failed
    func showAlert(){
        var loginAlert:UIAlertController = UIAlertController(title: "Login Failed", message: "Incorrect username or password", preferredStyle: UIAlertControllerStyle.Alert)
        
        loginAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(loginAlert, animated: true, completion: nil)
        
    }
    
}