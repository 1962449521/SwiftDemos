//
//  AppDelegate.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

var APPDataSource_iCloud: DrawDocument?
var APPDataSource_Local: NSMutableArray?
let APPDataSource_Local_FileURI = "/APPDataSource_Local.data"
let UBIQUITY_CONTAINER_URL = "iCloud.com.Disney.DrawingBoard.1000001"
let APPDataSource_iCloud_FileName = "APPDataSource_Local.data"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static func readDataFromLocal(){
        let DocumentsPath:String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let url: NSURL = NSURL(fileURLWithPath: DocumentsPath.stringByAppendingString(APPDataSource_Local_FileURI))
        if let readData = NSData(contentsOfFile: url.path!) {
            APPDataSource_Local = NSKeyedUnarchiver.unarchiveObjectWithData(readData) as? NSMutableArray
        } else {
            APPDataSource_Local = NSMutableArray(capacity: 0)
        }
    }
    static func saveDataToLocal(){
        if(APPDataSource_Local != nil){
            let writeData:NSData = NSKeyedArchiver.archivedDataWithRootObject(APPDataSource_Local!)
            let DocumentsPath:String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
            let url: NSURL = NSURL(fileURLWithPath: DocumentsPath.stringByAppendingString(APPDataSource_Local_FileURI))
            writeData.writeToURL(url, atomically: true)
        }
    }
    
    static func readDataFromiCloud(comletedBlock: ((Bool) -> Void)?){
        APPDataSource_iCloud = DrawDocument.init(fileURL: self.ubiquitousDocumentsURL()!)
        APPDataSource_iCloud!.openWithCompletionHandler { (isSuccess: Bool) -> Void in
            comletedBlock!(isSuccess)
        }
    }
    
    static func saveDataToiCloud(comletedBlock: ((Bool) -> Void)?){
        if(APPDataSource_iCloud != nil) {
            APPDataSource_iCloud?.updateChangeCount(.Done)
                           comletedBlock!(true)
        }
    }

    
    static func ubiquitousDocumentsURL() -> NSURL?{
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        let containerURL = fileManager.URLForUbiquityContainerIdentifier(UBIQUITY_CONTAINER_URL)
        return containerURL?.URLByAppendingPathComponent("Documents").URLByAppendingPathComponent(APPDataSource_iCloud_FileName)
    }
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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


}

