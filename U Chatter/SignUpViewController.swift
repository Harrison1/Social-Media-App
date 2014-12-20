//
//  SignUpViewController.swift
//  U Chatter
//
//  Created by Harrison McGuire on 12/5/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {

    //textfield variables from storyboard
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var emailConfirm: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passwordConfirm: UITextField!
    
    let genderScroll = ["Male", "Female", "Tranz", "Monster", "Crazy Motherfucker", "I'm My Own Gender"]
    
    //variable for default image
    let picture:UIImage = UIImage(named: "Vincent")!
    let picture2:UIImage = UIImage(named: "bic")!
    
    //manual viewcontroller variable
    let viewControllerRR:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("profileTablePage") as UIViewController
    

    @IBAction func SignUpButton(sender: AnyObject) {
        var chatter:PFUser = PFUser()
        chatter["firstName"] = self.firstName.text
        chatter["lastName"] = self.lastName.text
        chatter.email = self.email.text
        chatter.username = self.email.text
        chatter.password = self.password.text
        chatter["passwordConfirm"] = self.passwordConfirm.text
        
       
        //if formula to sign up user. I had to wrap the original if function in an if function because users
        //were being recorded with errors.
        if(chatter.email==self.emailConfirm.text && chatter.password==self.passwordConfirm.text && countElements(self.firstName.text) > 0 && countElements(self.lastName.text) > 0 ){
        chatter.signUpInBackgroundWithBlock{
        (success:Bool!, error:NSError!)-> Void in
            if (error == nil && chatter.email==self.emailConfirm.text && chatter.password==self.passwordConfirm.text && countElements(self.firstName.text) > 0 && countElements(self.lastName.text) > 0 ){
                
                //sets default picture for user
                let imageData = UIImagePNGRepresentation(self.picture)
                let imageFile = PFFile(name:"default_profile", data:imageData)
                var userPhoto = PFObject(className:"UserPhoto")
                userPhoto["imageFile"] = imageFile
                PFUser.currentUser().setObject(imageFile, forKey: "profileImage")
                //PFUser.currentUser().saveInBackgroundWithTarget(nil, selector: nil)
                
                let imageData2 = UIImagePNGRepresentation(self.picture2)
                let imageFile2 = PFFile(name:"beach", data:imageData2)
                var userPhoto2 = PFObject(className:"BackgroundImage")
                userPhoto2["imageFile2"] = imageFile2
                PFUser.currentUser().setObject(imageFile2, forKey: "backgroundImage")
                PFUser.currentUser().saveInBackgroundWithTarget(nil, selector: nil)
                
                println("Sign up successfull")
                    self.presentViewController(self.viewControllerRR, animated: true, completion: nil)
                    }else{
                        //let errorString = error.localizedDescription
                        //println(errorString)
                        self.showAlert()
                    }
                }
            } else{
                //let errorString = error.localizedDescription
                //println(errorString)
                self.showAlert()
            }
        }
    
    
    //function to show alert view that sign up failed
    func showAlert(){
        var loginAlert:UIAlertController = UIAlertController(title: "Sign Up Failed", message: "Incorrect information", preferredStyle: UIAlertControllerStyle.Alert)
        
        loginAlert.addAction(UIAlertAction(title: "Edit Info", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(loginAlert, animated: true, completion: nil)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderScroll.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return genderScroll[row]
    }

}