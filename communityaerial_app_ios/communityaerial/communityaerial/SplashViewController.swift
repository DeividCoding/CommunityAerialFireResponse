//
//  SplashViewController.swift
//  communityaerial
//
//  Created by Lisette HG on 07/10/23.
//

import UIKit
import CoreLocation

class SplashViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        let authorizationStatus = self.locationManager.authorizationStatus
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            self.startApp()
        } else {
            DispatchQueue.global().async {
               if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.startUpdatingLocation()
                }
            }
        }
    }
    
    
    func startApp(){
        let waitTime = 3.0
        let timer = Timer(timeInterval: waitTime, target: self, selector: #selector(loadTimer), userInfo: nil, repeats: false)
        
        RunLoop.current.add(timer, forMode: .common)
    }

    @objc func loadTimer() {
        self.navigationController?.setViewControllers([HomeViewController()], animated: true)
    }   
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            self.startApp()
        @unknown default:
            break
        }
    }


}
