//
//  TagCollectionViewCell.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    var activity: Activity?
    
    @IBOutlet var tagLabel: UILabel?
    
    @IBOutlet var tagView: UIView?
    @IBOutlet var tagImage: UIImageView?
    
    func setup(_ newActivity: Activity) {
        self.activity = newActivity

        self.tagLabel?.text = newActivity.title
        self.tagView?.backgroundColor = newActivity.color
        if #available(iOS 13.0, *) {
            self.tagImage?.image = UIImage(systemName: newActivity.icon)
        } else {
            // Fallback on earlier versions
            // TODO: Add fallback tag image
        }
    }
    
}
