//
//  RecipeType2.swift
//  VeganWay
//
//  Created by Oron Bernat on 21/02/2019.
//  Copyright © 2019 Bernat Investing. All rights reserved.
//

import Foundation
import UIKit

struct RecipeType2:Codable {
    
    let id:Int//id of reipe
    let image:String // URL with address to photo
    let name:String // of recipe -  שם המנה
    let rank:Int //
    let source:String //
    let ingredeints:[String]? //
}
