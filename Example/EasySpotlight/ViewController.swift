//
//  ViewController.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 09/10/2015.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var items:[SimpleStruct] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    //MARK: Outlets
    @IBAction func addNewElement(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Element", message: "enter title", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default){ _ in
            
            if let txt = alert.textFields?[0].text {
                let item = SimpleStruct(title:txt, identifier:txt)
                self.items.append(item)
                item.addToSpotlightIndex()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)

        alert.addTextFieldWithConfigurationHandler(nil)
        
        self.presentViewController(alert, animated: true, completion:nil)
    }
    
    @IBAction func removeAllElements(sender: UIBarButtonItem) {
        SimpleStruct.removeAllFromSpotlightIndex()
        //or items.removeFromSpotlightIndex()
    }

    @IBAction func addAllElements(sender: UIBarButtonItem) {
        items.addToSpotlightIndex()
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cellOk")
     
        cell.textLabel?.text = items[indexPath.row].title
        
        return cell
    }
}

