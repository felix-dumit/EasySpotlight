//
//  AppDelegate.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 09/10/2015.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

import UIKit
import EasySpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        EasySpotlight.registerIndexableHandler(SimpleStruct.self) { bobber in
            // handle when item is opened from spotlight
            print("started with struct: \(bobber.identifier)")
        }
        
        EasySpotlight.registerIndexableHandler(SimpleRealmClass.self) { obj in
            print("started with object: \(obj)")
            
            if let nav = application.keyWindow?.rootViewController as? UINavigationController, let vc = nav.topViewController as? ViewController {
                if let idx = vc.items?.index(of: obj) {
                    let ip = IndexPath(row: idx, section: 0)
                    vc.tableView.selectRow(at: ip, animated: true, scrollPosition: .top)
                }
            }
            
        }
        
        let ss = SimpleStruct(title: "Struct Item", contentDescription: "this is a struct", identifier: "simple_struct")
        EasySpotlight.index(ss)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return EasySpotlight.handle(activity: userActivity)
    }
}

