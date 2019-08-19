//
//  MainCollectionViewCell.swift
//  VeganWay
//
//  Created by Oron Bernat on 29/11/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Name: UILabel!

    override func awakeFromNib() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 12
        self.layer.cornerRadius = 12
    }
    
}
