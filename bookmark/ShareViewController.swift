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
            if let inputItem = item as? NSExtensionItem {
                for provider in inputItem.attachments! {
                    if provider.hasItemConformingToTypeIdentifier("public.url") {
                        return true
                    }
                }
            }
        }

        return false
    }

    override func didSelectPost() {
        for item in self.extensionContext!.inputItems {
            if let inputItem = item as? NSExtensionItem {
                for provider in inputItem.attachments! {
                   if provider.hasItemConformingToTypeIdentifier("public.url") {
                        provider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (result, _) in
                            self.post(url: String(describing: result!))
                        })
                    }
                }
            }
        }
    }

    func post(url: String) {
        let trimmedUrl = url.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let trimmedText = self.contentText == nil
            ? "" : self.contentText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        var body: String
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

        try! Util.realm.write {
            Util.realm.add(item)
        }

        let json: [String: Any] = ["note": body]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://v3zazo7g3g.execute-api.eu-west-1.amazonaws.com/notes")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) {_,_,_ in
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }

        task.resume()
    }

}
