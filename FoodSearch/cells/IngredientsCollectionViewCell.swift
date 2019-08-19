//
//  IngredientsCollectionViewCell.swift
//  VeganWay
//
//  Created by Oron Bernat on 06/12/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
//        109,255,134
        name.font = UIFont.init(name: "Arial", size: 16)
        self.layer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 50
    }
    
}
