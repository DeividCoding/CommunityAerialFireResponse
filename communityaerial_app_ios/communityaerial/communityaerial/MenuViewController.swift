//
//  MenuViewController.swift
//  communityaerial
//
//  Created by Lisette HG on 08/10/23.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var viewContainerInfo: UIView!
    @IBOutlet weak var viewContainerHome: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    let homeControler = HomeViewController()
    let inforController = InformationViewController()
    let mapController = MapsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.addViewControllerToContainer(homeControler, view: self.viewContainerHome)
        self.addViewControllerToContainer(inforController, view: self.viewContainerInfo)
        self.addViewControllerToContainer(mapController, view: self.viewMap)

        self.viewContainerHome.isHidden = false
        self.viewContainerInfo.isHidden = true
        self.viewMap.isHidden = true
        
        self.viewContainer.layer.cornerRadius = 20
        
        self.viewContainer.layer.shadowColor = UIColor.white.cgColor
        self.viewContainer.layer.shadowOpacity = 0.5
        self.viewContainer.layer.shadowRadius = 5.0
        self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    @IBAction func actionHome(_ sender: Any) {
        self.viewContainerHome.isHidden = false
        self.viewContainerInfo.isHidden = true
        self.viewMap.isHidden = true
    }
    
    @IBAction func actionInfo(_ sender: Any) {
        self.viewContainerHome.isHidden = true
        self.viewContainerInfo.isHidden = false
        self.viewMap.isHidden = true
    }
    
    @IBAction func actionMap(_ sender: Any) {
        self.viewContainerHome.isHidden = true
        self.viewContainerInfo.isHidden = true
        self.viewMap.isHidden = false
    }
    
    private func addViewControllerToContainer(_ viewController: UIViewController, view: UIView) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

}
