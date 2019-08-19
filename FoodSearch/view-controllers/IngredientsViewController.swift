//
//  IngredientsViewViewController.swift
//  VeganWay
//
//  Created by Oron Bernat on 03/12/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit
import MaterialComponents.MDCFeatureHighlightView



class IngredientsViewController: UIViewController{
    
    let ingredientsEnglish:[String] = [
        "salt", "pepper", "olive oil", "onine", "garlic", "rice", "potato", "tomato", "lemon", "suger", "coconut oil",
        "coconut", "parsley", "apple", "mushroom", "soya", "almonds", "chocolate", "nuts", "dates", "carrot",
        "tofu", "tehina", "wine", "flour", "soup powder", "powder", "mint"
    ]
    

    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var firstSelect = true
    var index:Int = 1
    var selectedIngre = Set<String>()
    var indexListSelected = Set<IndexPath>()
    var recipesArr = [Recipe]()
    let backgroungImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back1")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundView = self.backgroungImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        resetView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.string(forKey: "init") == nil{
            let tutorial = highLightStuff(title: "select ingredients", body:
                "We will let you know what you can we make :) Thank you RecipePupply.com"
            , item: lblTitle)
            let tutorialSecond = highLightStuff(title: "Click here", body: "To make a choose", item: collectionView)
            present(tutorial, animated: true, completion: {
                self.present(tutorialSecond, animated: true, completion: nil)
            })
            UserDefaults.standard.set("notFirst", forKey: "init")
        }
    }
    
    func resetView() {
        btnDone.isEnabled = true
        lblTitle.text = "Please Choose Ingredients"
        for cell in indexListSelected{
            collectionView.cellForItem(at: cell)?.layer.borderColor = UIColor.lightGray.cgColor
            collectionView.cellForItem(at: cell)?.layer.borderWidth = 3
        }
        self.selectedIngre.removeAll()
    }
    
    @IBAction func btnDone(_ sender: Any) {
        print(selectedIngre)
        if !recipesArr.isEmpty{
            recipesArr.removeAll()
        }
        if selectedIngre.isEmpty || selectedIngre.count <= 2 {
            self.lblTitle.text = "There is a Minimum of 3"
            return
        }
        btnDone.isEnabled = false
        guard let url = URL(string: "https://keymaker25.herokuapp.com/ingredientsCheck") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [ "Content-Type": "application/json" ]
        var array = [String]()
        for ingredient in selectedIngre{
            array.append(ingredient)
        }
        request.httpBody = try! JSONSerialization.data(withJSONObject: array, options: [])
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let d = data else{
                if let e = err{
                    print(e)
                }
                return
            }
            let resData:[Int] = {
                var str = String(data: d, encoding: .utf8)!
                str.removeFirst(2)
                str.removeLast(2)
                let temp = str.components(separatedBy: "\",\"")
                var intArray: [Int] = []
                for t in temp{
                    intArray.append(Int(t) ?? 388)
                }
                print(intArray)
                return intArray
            }();
            for num in resData{
                let newRecipe = RecipeDataBase.shared.Recipes[num-388]
                self.recipesArr.append(newRecipe)
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "RecipesByIngredients", sender: self.recipesArr)
            }
        }
        task.resume()
    }
  
    func highLightStuff(title:String, body:String, item:UIView)->MDCFeatureHighlightViewController  {
        let highlightController = MDCFeatureHighlightViewController(highlightedView: item)
        highlightController.titleText = title
        highlightController.bodyText = body
        highlightController.outerHighlightColor = UIColor.green.withAlphaComponent(kMDCFeatureHighlightOuterHighlightAlpha)
        return highlightController
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       guard let tran = segue.destination as? RecipeByIngredientsTableViewController else {return}
        tran.recipes = sender as! [Recipe]
        tran.title = "Recipes By Ingredients"
        resetView()
    }
}




extension IngredientsViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        _ = ingredientsEnglish[indexPath.row].count
        return CGSize(width: 120, height: 60)
//        var cellSize = CGSize(width: 0, height: 0)
//        switch size {
//        case 0..<8:
//            cellSize = CGSize(width: 120, height: 60)
//            break
//        case 8...Int.max:
//            cellSize = CGSize(width: 160, height: 60)
//            break
//        default:
//            cellSize = CGSize(width: 150, height: 100)
//        }
//        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.cellForItem(at: indexPath)?.layer.borderColor == UIColor.green.cgColor {
            
            indexListSelected.remove(indexPath)
            selectedIngre.remove(ingredientsEnglish[indexPath.row])
            collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.lightGray.cgColor
            collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 3
        }else{
            indexListSelected.insert(indexPath)
            selectedIngre.insert(ingredientsEnglish[indexPath.row])
            
            collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.green.cgColor
            collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredientsEnglish.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientsCell", for: indexPath) as! IngredientsCollectionViewCell
        let row = indexPath.row
        cell.name.backgroundColor = UIColor.clear
        cell.name.text = ingredientsEnglish[row]
        return cell
    }
    
}

