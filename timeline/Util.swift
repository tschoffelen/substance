//
//  Util.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import Foundation
import RealmSwift

class Util {

    static var realm: Realm {
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.co.schof.timeline")!
            .appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: fileURL)

        return try! Realm(configuration: config)
    }

}
