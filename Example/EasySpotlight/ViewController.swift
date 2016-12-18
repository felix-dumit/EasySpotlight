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
        items = try? Realm().objects(SimpleRealmClass.self)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadItems()
    }
    
    //MARK: Outlets
    @IBAction func addNewElement(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Element", message: "enter title", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default){ _ in
            
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

        alert.addTextField(configurationHandler: nil)
        
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func removeAllElements(_ sender: UIBarButtonItem) {
        SimpleRealmClass.removeAllFromSpotlightIndex()
        //or items.removeFromSpotlightIndex()
    }

    @IBAction func addAllElements(_ sender: UIBarButtonItem) {
        items?.addToSpotlightIndex()
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellOk")
     
        cell.textLabel?.text = items?[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let item = items?[(indexPath as NSIndexPath).row] else { return }
        
        item.removeFromSpotlightIndex { error in
            print("got error: \(error)")
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
    }
}


extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}
