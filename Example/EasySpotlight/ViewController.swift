//
//  ViewController.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 09/10/2015.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    var items:Results<SimpleRealmClass>?
    
    @IBOutlet weak var tableView: UITableView!
    
    func reloadItems() {
        items = try? Realm().objects(SimpleRealmClass)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadItems()
    }
    
    //MARK: Outlets
    @IBAction func addNewElement(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Element", message: "enter title", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default){ _ in
            
            if let txt = alert.textFields?[0].text {

                let item = SimpleRealmClass(name: txt, longDescription: "item with name \(txt)")
                let realm = try! Realm()
                try! realm.write {
                    realm.add(item)
                }
                
                item.addToSpotlightIndex()
                self.reloadItems()
            }
        }
        
        alert.addAction(action)

        alert.addTextFieldWithConfigurationHandler(nil)
        
        self.presentViewController(alert, animated: true, completion:nil)
    }
    
    @IBAction func removeAllElements(sender: UIBarButtonItem) {
        SimpleRealmClass.removeAllFromSpotlightIndex()
        //or items.removeFromSpotlightIndex()
    }

    @IBAction func addAllElements(sender: UIBarButtonItem) {
        items?.addToSpotlightIndex()
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cellOk")
     
        cell.textLabel?.text = items?[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard editingStyle == .Delete else { return }
        guard let item = items?[indexPath.row] else { return }
        
        item.removeFromSpotlightIndex { error in
            print("got error: \(error)")
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
        
    }
}


extension ViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
}
