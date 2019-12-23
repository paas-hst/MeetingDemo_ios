//
//  AppDelegate.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/25.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit
import ReactiveObjC


//FSP Manager
var fsp_manager = FspManager.sharedManager
let theApp = UIApplication.shared.delegate as! AppDelegate


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,FspManagerRemoteSignallingDelegate {
    func onInviteIncome(_ InviterUserId: String, inviteId nInviteId: Int32, groupId nGroupId: String, msg message: String?) {
        
    }
    
    func onInviteAccepted(_ RemoteUserId: String, inviteId nInviteId: Int32) {
        
    }
    
    func onInviteRejected(_ RemoteUserId: String, inviteId nInviteId: Int32) {
        
    }
    
    @objc
    var fspSignal: RACSubject = RACSubject()
    @objc
    var lagsignal: RACSubject = RACSubject()
    @objc
    var sysTemInfo: RACSubject = RACSubject()
    @objc
    var resetManager: RACSubject = RACSubject()
    
    
    
    let cpuMonitor: FspCpuMonitor = FspCpuMonitor.shareInstance()

    var window: UIWindow?
    lazy var nav: FspNavViewController = {
        let nav = FspNavViewController(rootViewController: fspLoginVC)
        return nav
    }()
    lazy var fspLoginVC: FspLoginViewController = {
        let fspLoginVC = FspLoginViewController.init(nibName: "FspLoginViewController", bundle: Bundle.main)
        return fspLoginVC
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .white
        self.window?.rootViewController = nav
        
        let isFirst = UserDefaults.standard.bool(forKey: "firstLaunch")
        if (!isFirst){
            UserDefaults.standard.set(true, forKey: "firstLaunch")
            print("首次进入,使用默认设置地址")
            UserDefaults.standard.set(false, forKey: CONFIG_KEY_USECONFIG)
            
        }else {
            ////直接进入主界面
            print("非首次进入")
            
        }
        
        _ = fsp_manager.initFsp()
   
        self.resetManager.subscribeNext { (id) in
            fsp_manager.destoryFsp()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                if fsp_manager.initFsp() {
                    print("重设成功")
                }
            })
    
        }
        
        
        cpuMonitor.begin()
        
        //初始化
        fsp_manager.singallingDelegate = self
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        fsp_manager.leaveGroup()
        fsp_manager.loginOut()
        fsp_manager.destoryFsp()
        
        cpuMonitor.end()
    }


}

