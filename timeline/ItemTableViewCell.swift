//
//  ItemTableViewCell.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var colorView: UIView?
    @IBOutlet var iconView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var bodyLabel: UITextView?

    func setup(item: TimelineItem) {
        self.colorView?.backgroundColor = item.color
        self.titleLabel?.textColor = item.color
        self.titleLabel?.text = item.title
        self.bodyLabel?.text = item.body
        self.dateLabel?.text = item.createdAt.relativeTime

        self.bodyLabel?.tintColor = UIColor.label
        self.iconView?.image = UIImage(systemName: item.icon)
    }

}
