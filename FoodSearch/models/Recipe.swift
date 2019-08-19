//
//  Receipe.swift
//  VeganWay
//
//  Created by Oron Bernat on 29/11/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import Foundation
import UIKit

struct Recipe:Codable {
    
    let id:Int//id of reipe
    let ingredients:[String] // arr of the ingredients
    let image:String // URL with address to photo
    let name:String // of recipe -  שם המנה
    let steps:[String] //instraction - אופן ההכנה
    let about:String // אודות המתכון

}


