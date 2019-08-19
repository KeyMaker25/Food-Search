//
//  RecipePageViewController.swift
//  VeganWay
//
//  Created by Oron Bernat on 15/12/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SnapKit


class RecipePageViewController: UIViewController {
    
    var currentRecipe:Recipe!
    var user = Auth.auth().currentUser
    var urlForLike = URLRequest(url: URL(string: "https://keymaker25.herokuapp.com/like")!)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let scrollView = UIScrollView()
    private var infoText = [UILabel()]
    private let infoName = UILabel()
    private let btnLike = UIButton()
    private let imageView = UIImageView()
    private let textContainer = UIView()
    
    private var previousStatusBarHidden = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.initImageContent()
    }
    
    func getIngredientsLbls() -> [UILabel] {
        var text:[UILabel] = []
        let first = UILabel()
        first.text = " Ingredients  "
        first.font = UIFont(name: "Arial" , size: 26)
        first.backgroundColor = .lightGray
        first.textColor = .white
        first.textAlignment = .center
        first.numberOfLines = 0
        text.append(first)
        for i in 0..<currentRecipe.ingredients.count {
            let lbl = UILabel.init()
            lbl.text = " -  \(currentRecipe.ingredients[i]) - "
            lbl.font = UIFont(name: "Calibri" , size: 24)
            lbl.backgroundColor = UIColor.init(displayP3Red: CGFloat((i+130)/255), green: CGFloat((i+200)/255), blue: CGFloat((i+240)/255), alpha: 0)
            lbl.textColor = .white
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            text.append(lbl)
        }
        return text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        
        btnLike.leftImage(image: UIImage(named: "like")!, renderMode: .automatic)
        btnLike.setTitle("Like", for: .normal)
        btnLike.titleLabel!.textAlignment = .center
        btnLike.titleLabel!.font = UIFont(name: "Arial", size: 26)
        btnLike.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
        btnLike.addTarget(self, action: #selector(Like), for: .touchUpInside)
    
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        infoName.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        infoName.textAlignment = .center
        infoName.textColor = .blue
        infoName.numberOfLines = 0
        infoName.text = "\(currentRecipe.name)"
        infoName.font = UIFont(name: "Arial" , size: 26)
        
        infoText = getIngredientsLbls()
        
        let imageContainer = UIView()
        imageContainer.backgroundColor = .darkGray
        
        textContainer.backgroundColor = .clear
        
        let textBacking = UIView()
        textBacking.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageContainer)
        scrollView.addSubview(textBacking)
        scrollView.addSubview(textContainer)
        scrollView.addSubview(imageView)
        
        textContainer.addSubview(infoName)
        
        scrollView.snp.makeConstraints {
            make in
            
            make.edges.equalTo(view)
        }
        
        imageContainer.snp.makeConstraints {
            make in
            
            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(imageContainer.snp.width).multipliedBy(0.7)
        }
        
        imageView.snp.makeConstraints {
            make in
            
            make.left.right.equalTo(imageContainer)
            
            //** Note the priorities
            make.top.equalTo(view).priority(.high)
            
            //** We add a height constraint too
            make.height.greaterThanOrEqualTo(imageContainer.snp.height).priority(.required)
            
            //** And keep the bottom constraint
            make.bottom.equalTo(imageContainer.snp.bottom)
        }
        
        textContainer.snp.makeConstraints {
            make in
            
            make.top.equalTo(imageContainer.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scrollView)
        }
        
        textBacking.snp.makeConstraints {
            make in
            
            make.left.right.equalTo(view)
            make.top.equalTo(textContainer)
            make.bottom.equalTo(view)
        }
        
        infoName.snp.makeConstraints {
            make in
            
            make.top.equalTo(textContainer)
            make.left.right.equalTo(view)
            make.height.equalTo(60)
            
        }
        for (i, item) in infoText.enumerated() {
            textContainer.addSubview(item)
            if i == 0 {
                item.snp.makeConstraints {
                    make in
                    make.top.equalTo(infoName.snp.bottom)
                    make.left.right.equalTo(textContainer)
                    make.height.equalTo(50)
                }
            }else if i == infoText.count-1 {
                item.snp.makeConstraints {
                    make in

                    make.top.equalTo(infoText[i-1].snp.bottom)
                    make.left.right.equalTo(textContainer)
                    make.height.equalTo(50)
//                    make.bottom.equalTo(textContainer).inset(14)
                }
            }else{
                item.snp.makeConstraints {
                    make in

                    make.top.equalTo(infoText[i-1].snp.bottom)
                    make.left.right.equalTo(textContainer)
                    make.height.equalTo(50)
                }
            }
        }
        
        textContainer.addSubview(btnLike)
        btnLike.snp.makeConstraints {
            make in
            
            make.top.equalTo(infoText[infoText.count-1].snp.bottom)
            make.left.right.equalTo(textContainer)
            make.height.equalTo(50)
            make.bottom.equalTo(textContainer).inset(14)
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.scrollIndicatorInsets = view.safeAreaInsets
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }


 

    func initImageContent() {
        let url = URL(string: currentRecipe.image)
        URLSession.shared.dataTask(with: url!) { (data, res, err) in
            guard let d = data else {
                if err != nil {print(err as Any)}
                  return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: d)
            }
        }.resume()
    }

    var isLogin = true
    
    @objc func Like() {
        if(user == nil){
            let alertVC = UIAlertController(title: "hey there!", message: "In order to like and save recipes, Log-in it's free", preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "Have account", style: .default , handler: { (action) in
            self.AlertControllerLogReg("Users Entry")
        }))
        alertVC.addAction(UIAlertAction(title: "Sign me up!", style: .default, handler: { (action) in
            self.isLogin = false
            self.AlertControllerLogReg("Registration")
        }))
            present(alertVC, animated: true)
        }else{
            likeRecipe()
        }
    }

    
    func AlertControllerLogReg(_ logTitle:String) {
        let loginRegAlert = UIAlertController.init(title: logTitle, message: nil, preferredStyle: UIAlertController.Style.alert)
        loginRegAlert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        loginRegAlert.addTextField { (textFieldpass) in
            textFieldpass.placeholder = "Password"
            textFieldpass.isSecureTextEntry = true
        }
        
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print(loginRegAlert.textFields!)
            let email:String = loginRegAlert.textFields![0].text!
            let pass:String = loginRegAlert.textFields![1].text!
            if (email.isEmpty || pass.isEmpty || email == " " || pass == " "){
                DispatchQueue.main.async {
                    loginRegAlert.dismiss(animated: true, completion: {
                        self.emptyTextFieldsFromUser()
                    })
                }
            }else{
                self.loginReg(email: email, pass: pass)
            }
            
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
            loginRegAlert.dismiss(animated: true)
        })
        
        loginRegAlert.addAction(actionCancel)
        loginRegAlert.addAction(actionOK)
        present(loginRegAlert, animated: true) { 
            print("loginRegAlert showed")
        }
        
    }
    
    func emptyTextFieldsFromUser() {
        let errorVC = UIAlertController(title: "Incorrect details", message: nil, preferredStyle: .alert)
        errorVC.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { (action) in
            errorVC.dismiss(animated: true)
        }))
        present(errorVC, animated: true)
    }
    
    func loginReg(email:String, pass:String){
        if isLogin {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (data, err) in
                guard let u = data?.user else{return}
                self.user = u
                if (self.userHaveDispalyName()){
                    self.likeRecipe()
                }
            })
         }else{
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (data, err) in
                guard let u = data?.user else{return}
                self.user = u
                self.likeRecipe()
            })
         }
    }
    
    func userHaveDispalyName() -> Bool {
        if(user?.displayName == nil || user?.displayName == "") {
            setUserDisplayName()
            return false
        }else{
            return true
        }
    }
    
    //setting the user display name.
    func setUserDisplayName() {
        let changeRequest = user!.createProfileChangeRequest()
        let nameVCAlert = UIAlertController(title: "Choose name please", message: "Private name is OK", preferredStyle: .alert)
        nameVCAlert.addTextField { (txt) in
            txt.placeholder = "Or just a nick"
        }
        nameVCAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            changeRequest.displayName = nameVCAlert.textFields![0].text
            print("display name changed to : \(String(describing: changeRequest.displayName))")
            changeRequest.commitChanges(completion: { (err) in
                if let err = err{
                    //err with commit
                    print(err)
                }else{
                    self.likeRecipe()
                }
            })
        }))
        present(nameVCAlert, animated: true)
    }
    
    //like func
    func likeRecipe(){
        let recipeID = currentRecipe.id
        guard let userUid = user?.uid else {
            print("user have no UID")
            return}
        guard let displayName = user?.displayName else {
            setUserDisplayName()
            return}
        
        let likeVCAlert = UIAlertController(title: "\(displayName)", message: " We like \(currentRecipe.name)", preferredStyle: .alert)
        likeVCAlert.addAction(
        UIAlertAction(title: "Like!", style: .default, handler:
            { (action) in
            let sendInfo:[String:Any] = [
                "user_id": userUid,
                "recipe_id": recipeID
            ]
            let sendJson = try! JSONSerialization.data(withJSONObject: sendInfo, options: [.prettyPrinted])
            self.urlForLike.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.urlForLike.httpMethod = "POST"
            self.urlForLike.httpBody = sendJson
            let task = URLSession.shared
            task.dataTask(with: self.urlForLike) {(data,res,err) in
                guard let d = data else {
                    print(err ?? "error")
                    return
                }
                if d.count == 2 {
                    print("in")
                    self.showLikeWasSuccess(true)
                }else{
                    print("not in")
                    self.showLikeWasSuccess(false)
                }
            }.resume()
        }))
        likeVCAlert.addAction(UIAlertAction(title: "No No", style: .destructive, handler: { (A) in
            DispatchQueue.main.async {
                 self.dismiss(animated: true)
            }
        }))
        present(likeVCAlert, animated: true)
    }
    
    func showLikeWasSuccess(_ isDone : Bool){
        var title = ""
        if isDone{
            title = "Done"
        }else{
            title = "You liked it already!"
        }
        let doneLikeAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        DispatchQueue.main.async {
            doneLikeAlert.addAction(UIAlertAction(title: "fantastick", style:  .default, handler: { (action) in
                doneLikeAlert.dismiss(animated: true)
            }))
            self.present(doneLikeAlert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewCV = segue.destination as! RecipePageWebViewController
        destViewCV.link = (sender as! String)
    }
    
    @IBAction func more(_ sender: Any) {
        print("open webview")
        performSegue(withIdentifier: "webview" , sender: currentRecipe.about)
    }
    
}

extension RecipePageViewController: UIScrollViewDelegate {
    
    //MARK: - Scroll View Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         navigationController?.isNavigationBarHidden = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.isNavigationBarHidden = true
        if previousStatusBarHidden != shouldHideStatusBar {
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
    
    
    //MARK: - Status Bar Appearance
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar: Bool {
        let frame = textContainer.convert(textContainer.bounds, to: nil)
        return frame.minY < view.safeAreaInsets.top
    }
}
