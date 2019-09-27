//
//  Activity.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

public final class Activity: Object {

    @objc dynamic var id = UUID().uuidString

    @objc dynamic var title: String?
    @objc dynamic var text: String?
    @objc dynamic var type: String?
    @objc dynamic var body: String?
    @objc dynamic var icon: String = "doc.fill"

    @objc dynamic var createdAt = Date()
    @objc dynamic public var isDeleted = false

    @objc dynamic var colorAsHex: String?
    @objc dynamic var color: UIColor {
        get {
            guard let hex = colorAsHex else { return UIColor.systemGreen }
            return UIColor(hex: hex)
        }
        set(newColor) {
            colorAsHex = newColor.toHex
        }
    }

    override public static func primaryKey() -> String? {
        return "id"
    }

    override public static func indexedProperties() -> [String] {
        return ["type", "title"]
    }

}

extension Activity: CKRecordConvertible {

}

extension Activity: CKRecordRecoverable {

}
