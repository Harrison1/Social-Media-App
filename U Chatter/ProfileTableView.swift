//
//  ProfileTableView.swift
//  U Chatter
//
//  Created by Harrison McGuire on 12/9/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import Foundation
import UIKit

class ProfileTableView: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var timelineData:NSMutableArray = NSMutableArray()
    
    var refreshControlR:UIRefreshControl!
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //let aVariable = appDelegate.createMenuView()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func loadData(){
        timelineData.removeAllObjects()
        
        var findTimelineData:PFQuery = PFQuery(className: "chats")
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil {
                for object in objects{
                    let chats:PFObject = object as PFObject
                    self.timelineData.addObject(chats)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func MenuButton(sender: AnyObject) {
        toggleLeft()
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
       return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ProfileTableViewCell {
        let cell:ProfileTableViewCell = tableView.dequeueReusableCellWithIdentifier("PCell", forIndexPath: indexPath) as ProfileTableViewCell

                let query = PFQuery(className: "User")
                
                query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]!, error: NSError!) in
                    if(error == nil){
                        
                        let user:PFUser = PFUser.currentUser() as PFUser
                        let pImage: PFFile = user["profileImage"] as PFFile
                        let bImage: PFFile = user["backgroundImage"] as PFFile
                        cell.firstName.text = user["firstName"] as? String
                        cell.lastName.text = user["lastName"] as? String
                        
                        pImage.getDataInBackgroundWithBlock{
                            (imageData:NSData!, error:NSError!)->Void in
                            
                            if error == nil {
                                let image:UIImage = UIImage(data: imageData)!
                                cell.profileImageCell.image = image
                            } else{
                                println("Error in retrieving \(error)")
                            }
                        }
                        
                        bImage.getDataInBackgroundWithBlock{
                            (imageData:NSData!, error:NSError!)->Void in
                            
                            if error == nil {
                                let image:UIImage = UIImage(data: imageData)!
                                cell.backgroundImageCell.image = image
                            } else{
                                println("Error in retrieving \(error)")
                            }
                        }
                        
                    }
                })
                return cell
            }
}