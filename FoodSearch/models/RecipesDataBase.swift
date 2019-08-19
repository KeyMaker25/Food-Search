//
//  RecipesDataBase.swift
//  VeganWay
//
//  Created by Oron Bernat on 30/11/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SQLite3

protocol DataBaseDelegate {
    func isReady(ready:Bool)
}

class RecipeDataBase: NSObject {
    
    static let shared = RecipeDataBase()
    var Recipes = [Recipe]()
    var bestRecipes = [Recipe]()
    var ingredients = [Any]()
    let bestRecipsSource = URL(string: "https://keymaker25.herokuapp.com/bestRecipesId")!
    let collectionCellUrl = URL(string: "https://keymaker25.herokuapp.com/fullrecipes")!
    
    private override init(){
        super.init()
    }
    
    func myinit(delegate:DataBaseDelegate){
        
        let session = URLSession.shared
        session.dataTask(with: collectionCellUrl) { (data, res, err) in
            guard let d = data else {
                print(err ?? "error")
                delegate.isReady(ready:false)
                return
            }
            guard let myData = try? JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [Any] else{
                return
            }
            let recipes = myData[0] as! [Json]
            self.ingredients = myData[1] as! [Any]
            let recipesCount:Int = recipes.count
            print("we have : \(recipesCount) recipes in DB")
            for i in 0..<recipesCount{

                let recipeId = recipes[i]["id"] as! Int
                let img = recipes[i]["image_url"] as! String
                let name = recipes[i]["name"] as! String
                let steps = recipes[i]["healthlabels"] as! String
                let about = recipes[i]["about"] as! String
                let ingre = self.ingredients[recipeId] as! [String]
                let newRecipe = Recipe(id: recipeId,ingredients: ingre , image: img, name: name, steps: [steps], about: about)
                

                DispatchQueue.main.async {
                    self.Recipes.append(newRecipe)
                }
                if (i == 250){
                    delegate.isReady(ready:true)
                }
            }
            self.getBestRecipes()
            
        }.resume()
        
    }
    
    func getBestRecipes() {
        let task = URLSession.shared
        task.dataTask(with: bestRecipsSource) {(data, res, err) in
            guard let d = data else {
                print(err ?? "error")
                return
            }
            let result = try! JSONSerialization.jsonObject(with: d, options: [.mutableContainers]) as! [Json]
            for ra in result {
                let recipeid = ra["recipe_id"] as! Int
                let likes = Int(ra["like_count"] as! String)!
                if(likes>=0){
                    for r in self.Recipes{
                        if (r.id == recipeid){
                            self.bestRecipes.append(r)
                            print("best recipe added: \(r.name)")
                        }
                    }
                }
            }
        }.resume()
    }
    
    
}

