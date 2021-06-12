//
//  AppDelegate.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit
import Sentry
import IceCream
import RealmSwift
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    var syncEngine: SyncEngine?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Create a Sentry client and start crash handler
        SentrySDK.start { options in
            options.dsn = "https://b3041dff5fb841449d4aee8722c5a03c@sentry.io/1865550"
        }

        // Set up iCloud sync engine
//        syncEngine = SyncEngine(objects: [
//                SyncObject<TimelineItem>(),
//                SyncObject<Activity>()
//            ], databaseScope: .private)

        // Enable remote notifications for iCloud sync
        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let dict = userInfo as? [String: NSObject],
           let notification = CKNotification(fromRemoteNotificationDictionary: dict),
           let subscriptionID = notification.subscriptionID, IceCreamSubscription.allIDs.contains(subscriptionID) {
            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
            completionHandler(.newData)
        }
    }

}
