//
//  AppDelegate.swift
//  Address Book
//
//  Created by Maniu Suroiu on 25/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack(modelName: "Address Book")
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    /* Get a reference to the AddressBookViewController */
    guard let navigationController = window?.rootViewController as? UINavigationController,
      let addressBookViewController = navigationController.topViewController as? AddressBookViewController else {
      return true
    }
    
    /* Propagate the managed context from CoreDataStack (initializing the whole stack in the process) to AddressBookViewController */
    addressBookViewController.managedContext = coreDataStack.managedConetxt
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    coreDataStack.saveContext()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    /* Core Data saves any pending changes before the app is terminated */
    coreDataStack.saveContext()
  }
}

