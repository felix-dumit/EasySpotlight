//
//  ViewController.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 09/10/2015.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

import UIKit
import RealmSwift
import EasySpotlight

class ViewController: UIViewController {

    var items: Results<SimpleRealmClass>?

    @IBOutlet weak var tableView: UITableView!

    func reloadItems() {
        items = try? Realm().objects(SimpleRealmClass.self)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadItems()
    }

    // MARK: Outlets
    @IBAction func addNewElement(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "New Element", message: "enter title", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { _ in

            if let txt = alert.textFields?[0].text {

                let item = SimpleRealmClass(name: txt, longDescription: "item with name \(txt)")
                //swiftlint:disable force_try
                let realm = try! Realm()
                try! realm.write {
                    realm.add(item)
                }
                //swiftlint:enable force_try

                EasySpotlight.index(item) { error in
                    print("error indexing: \(error as Any)")
                }
                self.reloadItems()
            }
        }

        alert.addAction(action)

        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func removeAllElements(_ sender: UIBarButtonItem) {
        EasySpotlight.deIndexAll(of: SimpleRealmClass.self)
    }

    @IBAction func addAllElements(_ sender: UIBarButtonItem) {
        if let items = items {
            EasySpotlight.index(Array(items))
        }
    }
}

extension ViewController: UITableViewDataSource {
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

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let item = items?[(indexPath as NSIndexPath).row] else { return }

        EasySpotlight.deIndex(item) { error in
            print("got error: \(error as Any)")
        }

        //swiftlint:disable force_try
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
        //swiftlint:enable force_try

        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}
