//
//  TagCollectionViewCell.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet var tagLabel: UILabel?

    @IBOutlet var tagView: UIView?
    @IBOutlet var tagImage: UIImageView?

    func setup(_ activity: Activity) {
        self.tagLabel?.text = activity.title
        self.tagView?.backgroundColor = activity.color
        self.tagImage?.image = UIImage(systemName: activity.icon)
    }

}
