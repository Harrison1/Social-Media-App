//
//  ComposeViewController.swift
//  U Chatter
//
//  Created by Harrison McGuire on 11/12/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var uChatTextView: UITextView! = UITextView()
    
    @IBOutlet var charRemaining: UILabel! = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uChatTextView.layer.borderColor = UIColor.blackColor().CGColor
        uChatTextView.layer.borderWidth = 0.5
        uChatTextView.layer.cornerRadius = 5
        uChatTextView.delegate = self
        
        uChatTextView.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendChat(sender: AnyObject) {
        
        var chat:PFObject = PFObject(className: "chats")
        chat["content"] = uChatTextView.text
        chat["chatter"] = PFUser.currentUser()
        
        chat.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                NSLog("Object created with id: \(chat.objectId)")
            } else {
                NSLog("%@", error)
            }
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool{
            
            var newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            var remainingChar:Int = 140 - newLength
            
            charRemaining.text = "\(remainingChar)"
            
            return (newLength > 139) ? false : true
    
    }
    

}
