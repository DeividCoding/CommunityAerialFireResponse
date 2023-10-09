//
//  HomeViewController.swift
//  communityaerial
//
//  Created by Lisette HG on 07/10/23.
//

import UIKit
import CoreLocation

enum DangerLevel: String {
    case none = "No Danger"
    case low = "Low Danger"
    case medium = "Medium Danger"
    case high = "High Danger"

    func getColor() -> UIColor {
        switch self {
        case .none:
            return UIColor.green
        case .low:
            return UIColor.yellow
        case .medium:
            return UIColor.orange
        case .high:
            return UIColor.red
        }
    }
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var labelMeters: UILabel!
    @IBOutlet weak var buttonSOS: UIButton!
    @IBOutlet weak var viewBlackPhoneNumbers: UIView!
    @IBOutlet weak var labelLocationStatus: UILabel!
    
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var labelLocation: UILabel!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewBlackPhoneNumbers.layer.cornerRadius = 20
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        
        let currentDangerLevel = DangerLevel.high
        let attributedString = NSMutableAttributedString(string: "Currently, you are in an area with ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let dangerLevelString = NSAttributedString(string: currentDangerLevel.rawValue, attributes: [NSAttributedString.Key.foregroundColor: currentDangerLevel.getColor()])
        attributedString.append(dangerLevelString)
        self.labelLocationStatus.attributedText = attributedString
        
    }
    
    func getRandomDangerLevel() -> DangerLevel {
        let dangerLevels: [DangerLevel] = [.none, .low, .medium, .high]
        let randomIndex = Int(arc4random_uniform(UInt32(dangerLevels.count)))
        return dangerLevels[randomIndex]
    }
    
    @IBAction func actionSOS(_ sender: Any) {
        self.navigationController?.pushViewController(SOSViewController(), animated: true)
    }
    
    @IBAction func actionFireFighter(_ sender: Any) {
        self.makeCall(phone: "tel://5555558420")
    }
    
    @IBAction func actionAmbulance(_ sender: Any) {
        self.makeCall(phone: "tel://5521572070")
    }
    
    @IBAction func actionPolice(_ sender: Any) {
        self.makeCall(phone: "tel://911")
    }
    
    @IBAction func actionMoreInformation(_ sender: Any) {
    }
    func makeCall(phone: String){
        if let phoneURL = URL(string: phone) {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let formattedLatitude = String(format: "%.6f", latitude)
            let formattedLongitude = String(format: "%.6f", longitude)
            let distanciaEnMetros = calcularDistancia(latInicial: latitude, lonInicial: longitude)
            let distanciaFormateada = String(format: "%.4f", distanciaEnMetros)

            self.labelLocation.text = "Location: \(formattedLatitude), \(formattedLongitude)"
            self.labelMeters.text = ("Caution! \nYou are approximately  \n\(distanciaFormateada) meters \naway from a fire.")

        }
    }
    
    func calcularDistancia(latInicial: Double, lonInicial: Double) -> CLLocationDistance {
        let coordenadaInicial = CLLocation(latitude: latInicial, longitude: lonInicial)
        let coordenadaFinal = CLLocation(latitude: 19.2793897, longitude: -99.1748528)
        
        return coordenadaInicial.distance(from: coordenadaFinal)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error de ubicación: \(error.localizedDescription)")
    }
}
