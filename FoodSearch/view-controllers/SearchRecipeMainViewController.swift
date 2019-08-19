//
//  ViewController.swift
//  VeganWay
//
//  Created by Oron Bernat on 29/11/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit
import FirebaseAuth

class SearchRecipeMainViewController: UIViewController, DataBaseDelegate{
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var LoadingView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnPageTitle: UINavigationItem!
    @IBOutlet weak var btnSignOut: UIBarButtonItem!
    
    var searchRecipes:[Recipe] = []
    var arrRecipes:[Recipe] = []
    var isLoading:Bool = true
    let backgroungImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back2")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHideLoadinScreen()
        searchBarInit()
        RecipeDataBase.shared.myinit(delegate: self)
        loader.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let dis = Auth.auth().currentUser?.displayName else {return}
        self.title = " Hey \(dis)"
        btnSignOut.isEnabled = true
    }
    
    func showHideLoadinScreen(){
        if(isLoading){
            navigationController?.navigationBar.isHidden = true
            view.addSubview(LoadingView)
            LoadingView.snp.makeConstraints {
                make in
                
                make.edges.equalTo(view)
            }
            isLoading = false
            let user = Auth.auth().currentUser
            guard let u = user, let dis = u.displayName else {
                btnSignOut.isEnabled = false
                return
            }
            if (!dis.isEmpty || dis != ""){
                self.btnPageTitle.title = " היי \(dis)"
            }
        }else{
            arrRecipes = RecipeDataBase.shared.Recipes
            searchRecipes = arrRecipes
            DispatchQueue.main.async {
                self.CollectionView.backgroundView = self.backgroungImage
                self.LoadingView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func btnSignOut(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            btnSignOut.isEnabled = false
            showLogOutAlert()
        }catch{
            print(error)
        }
    }
    
    func searchBarInit(){
        searchBar.placeholder = "Recipe by name"
        searchBar.barStyle = UIBarStyle.default
        searchBar.delegate = self
        searchBar.keyboardAppearance = UIKeyboardAppearance.default
    }
    
    func showLogOutAlert() {
        self.title = "Recipe by name"
        let logOutAlert = UIAlertController(title: "That's it?", message: "See you soon :)", preferredStyle: .alert)
        logOutAlert.addAction(UIAlertAction(title: "Ok bye for now", style: .cancel, handler: { (action) in
            logOutAlert.dismiss(animated: true)
        }))
        present(logOutAlert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewCV = segue.destination as! RecipePageViewController
        destViewCV.currentRecipe = sender as? Recipe
    }
    
    func isReady(ready: Bool) {
        if(ready){
            print("DB ready")
            showHideLoadinScreen()
            DispatchQueue.main.async{
                self.loader.stopAnimating()
                self.loader.isHidden = true
                self.navigationController?.navigationBar.isHidden = false
                self.tabBarController?.tabBar.isHidden = false
                self.CollectionView.reloadData()
            }
        }else{
            print("Ethernet Promblem")
            let alertVC = UIAlertController.init(title: "ERROR", message: "Ethernet Promblem", preferredStyle: UIAlertController.Style.alert)
            alertVC.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.destructive, handler: { (done) in
                    print("App closed due to ethernet problems")
            }))
            present(alertVC, animated: true)
            
        }
    }
}






extension SearchRecipeMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.3
        return CGSize(width: size, height: size)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchRecipes.count
    }
  
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.searchBar.isHidden = false
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate){
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.7, delay: 0.3, options: [.curveEaseIn, .curveLinear], animations: {
                    self.searchBar.isHidden = false
                }, completion: nil)
            }
        }
    }
    //on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        if(scrollView.isDragging){
            DispatchQueue.main.async {
                self.searchBar.isHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mainMoveToRecipe", sender: searchRecipes[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainCollectionViewCell
        let row = indexPath.row
        let data = searchRecipes[row]
        let url = URL(string: data.image)
        URLSession.shared.dataTask(with: url!) { (data, res, err) in
            if let e = err {
                print(e)
            }
            if let d = data {
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: d)
                }
            }
        }.resume()
        var sortName = data.name.replacingOccurrences(of: "Vegan", with: "", options: [.caseInsensitive, .regularExpression])
        if sortName.count > 10{
            let t = sortName.split(separator: " ")
            sortName = String(t[0]+t[1])
            sortName = sortName.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")

        }
        cell.Name.text = sortName
        return cell
    }
}

extension SearchRecipeMainViewController : UISearchBarDelegate {
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRecipes = searchText.isEmpty ? arrRecipes : arrRecipes.filter({ (Recipe) -> Bool in
                return Recipe.name.lowercased().contains(searchText.lowercased())
            })
        CollectionView.reloadData()
    }
    
}

