//
//  AppDelegate.swift
//  SwiftDisplay-iOS-Demo
//
//  Created by Zhu Shengqi on 2018/11/4.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let mainWindow = UIWindow()
    self.window = mainWindow
    
    mainWindow.rootViewController = UINavigationController(rootViewController: MainViewController())
    mainWindow.makeKeyAndVisible()
    
    return true
  }
  

}

