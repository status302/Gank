//
//  AppDelegate.swift
//  Gank
//
//  Created by 程庆春 on 16/5/17.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        window?.backgroundColor = UIColor.whiteColor()

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ViewController
        window?.rootViewController = vc

        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 3))
        dispatch_after(time, dispatch_get_main_queue()) {

            self.window?.rootViewController = QCTabBarController()
        }
        window?.makeKeyAndVisible()


        // 设置kingfisher的最大缓存空间
        let cache = KingfisherManager.sharedManager.cache
        cache.maxMemoryCost = 30 * 1024 * 1024
        cache.maxDiskCacheSize = 30 * 1024 * 1024

        self.realmSchemaMigration()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    private func realmSchemaMigration() {
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { (migration, oldSchemaVersion) in
            migration.enumerate(SortResult.className(), { (oldObject, newObject) in
                if oldSchemaVersion < 1 {
                    newObject!["isCollected"] = false
                }
            })
        })
        Realm.Configuration.defaultConfiguration = config
    }

}

