//
//  AppDelegate.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 7/27/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    - (BOOL)application:(UIApplication *)application
//    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    
//    [[FBSDKApplicationDelegate sharedInstance] application:application
//    didFinishLaunchingWithOptions:launchOptions];
//    // Add any custom logic here.
//    return YES;
//    }
//    
//    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
//    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//    openURL:url
//    sourceApplication:sourceApplication
//    annotation:annotation
//    ];
//    // Add any custom logic here.
//    return handled;
//    }
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

