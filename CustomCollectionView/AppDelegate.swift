//
//  AppDelegate.swift
//  CustomCollectionView
//
//  Created by AST-iMac-0015 on 7/1/16.
//  Copyright © 2016 AST-iMac-0015. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        
        let home = CollectionViewController(nibName: "CollectionViewController", bundle: nil)
        let naviController = UINavigationController(rootViewController: home)
        naviController.navigationBarHidden = false
        self.window?.rootViewController = naviController
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
      
    }

    func applicationDidEnterBackground(application: UIApplication) {
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
      
    }

    func applicationDidBecomeActive(application: UIApplication) {
   
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

