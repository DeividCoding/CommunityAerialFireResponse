//
//  SplashViewController.swift
//  simulationdead
//
//  Created by Lisette HG on 07/10/23.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        let waitTime = 3.0
        let timer = Timer(timeInterval: waitTime, target: self, selector: #selector(loadTimer), userInfo: nil, repeats: false)
        
        RunLoop.current.add(timer, forMode: .common)
    }

    
    @objc func loadTimer() {
        self.navigationController?.setViewControllers([DeadLandViewController()], animated: true)
    }
    

}
