//
//  ItemTableViewCell.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit
import ActiveLabel

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var colorView: UIView?
    @IBOutlet var iconView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var bodyLabel: ActiveLabel?

    public var delegate: ViewController?

    func setup(item: TimelineItem) {
        self.colorView?.backgroundColor = item.color
        self.iconView?.image = UIImage(systemName: item.icon)

        self.titleLabel?.textColor = item.color
        self.titleLabel?.text = item.title
        self.dateLabel?.text = item.createdAt.relativeTime

        self.bodyLabel?.customize { label in
            label.tintColor = UIColor.label
            label.text = item.body
            label.urlMaximumLength = 30
            label.handleMentionTap { self.delegate?.handleTap(type: "contact", value: $0) }
            label.handleHashtagTap { self.delegate?.handleTap(type: "label", value: $0) }
            label.handleURLTap { self.delegate?.handleTap(type: "url", value: $0.absoluteString) }
        }
    }

}
