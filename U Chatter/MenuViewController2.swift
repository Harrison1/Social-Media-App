//
//  MenuViewController2.swift
//  U Chatter
//
//  Created by Harrison McGuire on 12/14/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import UIKit

class MenuViewController2: UITableViewController {
    
    // create references to the items on the storyboard
    // so that we can animate their properties
    
    let image1: UIImage = UIImage(named: "bic")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
}
