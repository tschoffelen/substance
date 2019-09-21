//
//  TimelineItem.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

public final class TimelineItem: Object {
    
    @objc dynamic var id = UUID().uuidString

    @objc dynamic var body: String?
    @objc dynamic var title = "Note"
    @objc dynamic var type = "note"
    @objc dynamic var icon = "doc.fill"
    
    @objc dynamic var createdAt = Date()
    @objc dynamic public var isDeleted = false
    
    @objc dynamic var activity: Activity?
    
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

extension TimelineItem: CKRecordConvertible {

}

extension TimelineItem: CKRecordRecoverable {

}
