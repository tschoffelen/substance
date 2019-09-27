//
//  AppDelegate.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import IceCream
import RealmSwift
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var syncEngine: SyncEngine?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        Fabric.with([Crashlytics.self])

        syncEngine = SyncEngine(objects: [
                SyncObject<TimelineItem>(),
                SyncObject<Activity>()
            ], databaseScope: .private)
        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if let dict = userInfo as? [String: NSObject] {
            let notification = CKNotification(fromRemoteNotificationDictionary: dict)
            if let subscriptionID = notification?.subscriptionID, IceCreamSubscription.allIDs.contains(subscriptionID) {
                NotificationCenter.default.post(
                    name: Notifications.cloudKitDataDidChangeRemotely.name,
                    object: nil,
                    userInfo: userInfo
                )
                completionHandler(.newData)
            }
        }

    }

}
