//
//  RecipeCellTableViewCell.swift
//  VeganWay
//
//  Created by Oron Bernat on 14/12/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    
    override func awakeFromNib() {
        self.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 7
    }
    
}
