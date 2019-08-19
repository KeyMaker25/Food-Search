//
//  MainTabBarController.swift
//  VeganWay
//
//  Created by Oron Bernat on 29/11/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit



class CustomTabBarController: UITabBarController {
    
    @IBOutlet weak var tapBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init the Home bar item as the initial one
        self.selectedIndex = 1
        // Do any additional setup after loading the view.
    }
}

typealias Json = [String: Any]

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}
