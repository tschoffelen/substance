//
//  ShareViewController.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit
import Social
import RealmSwift
import IceCream

class ShareViewController: SLComposeServiceViewController {

    var syncEngine: SyncEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncEngine = SyncEngine(objects: [
            SyncObject<TimelineItem>(),
            SyncObject<Activity>()
        ], databaseScope: .private)
    }
    
    override func isContentValid() -> Bool {
        for item in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    return true
                }
            }
        }

        return false
    }

    override func didSelectPost() {
        for item in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (result, error) in
                        self.post(url: String(describing: result!))
                    });
                }
            }
        }
    }
    
    func post(url: String) {
        let trimmedUrl = url.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let trimmedText = self.contentText == nil ? "" : self.contentText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        var body : String
        if trimmedText.count > 0, trimmedText != trimmedUrl {
            body = "\(trimmedText) \(trimmedUrl)"
        } else {
            body = "\(trimmedUrl)"
        }
        
        let item = TimelineItem()
        item.body = body
        item.title = "Bookmark"
        item.type = "bookmark"
        item.color = UIColor.systemPurple
        item.icon = "bookmark.fill"
        
        try! Util.realm.write() {
            Util.realm.add(item)
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

}
