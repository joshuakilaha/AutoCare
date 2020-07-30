//
//  SplashScreenViewController.swift
//  Auto Care
//
//  Created by JJ Kilz on 27/07/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

 // 1. Create the AnimationView
    private var animationView: AnimationView?

    override func viewDidLoad() {

      super.viewDidLoad()
      
     lottieVisa()
      
    }
    


    private func ToMainView() {
        let toMain = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "toMainView") 
    }
    
    
    private func lottieVisa() {
        // 2. Start AnimationView with animation name (without extension)
             
             animationView = .init(name: "engine")
             
             animationView!.frame = view.bounds
             
             // 3. Set animation content mode
             
             animationView!.contentMode = .scaleAspectFit
             
             // 4. Set animation loop mode
             
             animationView!.loopMode = .loop
             
             // 5. Adjust animation speed
             
             animationView!.animationSpeed = 0.5
             
             view.addSubview(animationView!)
             
             // 6. Play animation
             
             animationView!.play()
    }
 

}
