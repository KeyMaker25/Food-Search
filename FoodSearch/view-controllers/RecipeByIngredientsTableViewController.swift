//
//  RecipeByIngredientsTableViewController.swift
//  VeganWay
//
//  Created by Oron Bernat on 14/12/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit
import Foundation

class RecipeByIngredientsTableViewController: UIViewController {
    
    var recipes = [Recipe]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipes.count < 3 {
            print("no ingredient show likes")
            recipes = RecipeDataBase.shared.bestRecipes
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewCV = segue.destination as! RecipePageViewController
        destViewCV.currentRecipe = sender as? Recipe
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !recipes.isEmpty {
            tableView.reloadData()
        }
    }


}

extension RecipeByIngredientsTableViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(recipes[row].name)
        performSegue(withIdentifier: "bestMoveToRecipe", sender: recipes[row])
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let row = indexPath.row
        let data = recipes[row]
        var sortName = data.name
        if sortName.count > 20{
            let t = sortName.split(separator: " ")
            var temp = t.count
            sortName = ""
            if temp > 5 {temp = 5}
            for i in 0..<temp-1{
                sortName += " "+String(t[i])
            }
            sortName = sortName.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
        }
        cell.recipeName.text = sortName
        let url = URL(string: data.image)
        URLSession.shared.dataTask(with: url!) { (data, res, err) in
            guard let d = data else {
                if let e = err{print(e)}
                return}
            DispatchQueue.main.async {
                cell.recipeImage.image = UIImage(data: d)
            }
        }.resume()
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
}
