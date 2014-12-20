//
//  TimelineTableViewController.swift
//  U Chatter
//
//  Created by Harrison McGuire on 11/12/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var timelineData:NSMutableArray = NSMutableArray()
    
    var refreshControlR:UIRefreshControl! // An optional variable
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func loadData(){
        timelineData.removeAllObjects()
        
        var findTimelineData:PFQuery = PFQuery(className: "chats")
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil {
                for object in objects{
                    let chats:PFObject = object as PFObject
                    self.timelineData.addObject(chats)
                }
                
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.refreshControlR = UIRefreshControl()
        self.refreshControlR.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControlR.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControlR)
    }
    
    func refresh(sender:AnyObject)
    {
        timelineData.removeAllObjects()
        
        var findTimelineData:PFQuery = PFQuery(className: "chats")
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil {
                for object in objects{
                    let chats:PFObject = object as PFObject
                    self.timelineData.addObject(chats)
                }
                
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                self.tableView.reloadData()
            }
        }
        
        self.refreshControlR.endRefreshing()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.loadData()
        
        var footerView:UIView = UIView(frame: CGRectMake(0,0, self.view.frame.size.width, 50))
        self.tableView.tableFooterView = footerView
        
        var logoutButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        logoutButton.frame = CGRectMake(20, 10, 50, 20)
        logoutButton.setTitle("Logout", forState: UIControlState.Normal)
        logoutButton.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
        
        footerView.addSubview(logoutButton)
        
        if PFUser.currentUser() == nil {
            self.showLoginSignup()
            
        }
    }
    
    func showLoginSignup(){
        var loginAlert:UIAlertController = UIAlertController(title: "Sign Up / Login", message: "Please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
        
        loginAlert.addTextFieldWithConfigurationHandler({
            textfield in
            textfield.placeholder = "Your username"
        })
        
        loginAlert.addTextFieldWithConfigurationHandler({
            textfield in
            textfield.placeholder = "Your password"
            textfield.secureTextEntry = true
        })
        
        loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            let textFields:NSArray = loginAlert.textFields! as NSArray
            let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
            let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
            
            var chatter:PFUser = PFUser()
            chatter.username = usernameTextfield.text
            chatter.password = passwordTextfield.text
            
            PFUser.logInWithUsernameInBackground(chatter.username, password: chatter.password) {
                (user:PFUser!, error:NSError!)->Void in
                if user != nil {
                    println("Login successfull")
                } else {
                    println("login failed")
                    self.presentViewController(loginAlert, animated: true, completion: nil)
                }
            }
            
        }))
        
        
        loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            let textFields:NSArray = loginAlert.textFields! as NSArray
            let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
            let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
            
            var chatter:PFUser = PFUser()
            chatter.username = usernameTextfield.text
            chatter.password = passwordTextfield.text
            
            chatter.signUpInBackgroundWithBlock{
                (success:Bool!, error:NSError!)-> Void in
                if error == nil{
                    println("Sign up successfull")
                    var imagePicker:UIImagePickerController = UIImagePickerController()
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                    imagePicker.delegate = self
                    
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                    
                }else{
                    let errorString = error.localizedDescription
                    println(errorString)
                }
            }
            
        }))
        
        self.presentViewController(loginAlert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        
        let pickedImage:UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        // Scale down image
        let scaledImage = self.scaleImageWith(pickedImage, and: CGSizeMake(100,100))
        
        let imageData = UIImagePNGRepresentation(scaledImage)
        
        let imageFile:PFFile = PFFile(data: imageData)
        
        PFUser.currentUser().setObject(imageFile, forKey: "profileImage")
        PFUser.currentUser().saveInBackgroundWithTarget(nil, selector: nil)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func scaleImageWith(image:UIImage, and newSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func logout(sender:UIButton){
        PFUser.logOut()
        self.showLoginSignup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return timelineData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UChatTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UChatTableViewCell
        
        let chat:PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject
        
        cell.chatTextView.alpha = 0
        cell.timestamp.alpha = 0
        cell.userName.alpha = 0
        
        cell.chatTextView.text = chat.objectForKey("content") as String
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.timestamp.text = dateFormatter.stringFromDate(chat.createdAt)
        
        var findChatter:PFQuery = PFUser.query()
        findChatter.whereKey("objectId", equalTo: chat.objectForKey("chatter").objectId)
        
        findChatter.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error == nil {
                let user:PFUser = (objects as NSArray).lastObject as PFUser
                cell.userName.text = user.username
                
                // Profile Image
                cell.profileImageView.alpha = 0
                cell.profileImageView.layer.cornerRadius = 25.0
                cell.profileImageView.clipsToBounds = true
                
                let profileImage:PFFile = user["profileImage"] as PFFile
                
                profileImage.getDataInBackgroundWithBlock{
                    (imageData:NSData!, error:NSError!)->Void in
                    
                    if error == nil {
                        let image:UIImage = UIImage(data: imageData)!
                        cell.profileImageView.image = image
                    }
                }
                
                UIView.animateWithDuration(0.5, animations: {
                    cell.chatTextView.alpha = 1
                    cell.timestamp.alpha = 1
                    cell.userName.alpha = 1
                    cell.profileImageView.alpha = 1
                    
                })
            }
            
        }
        
        return cell
    }
    
}
