//
//  DeadLandViewController.swift
//  simulationdead
//
//  Created by Lisette HG on 07/10/23.
//

import UIKit
import MapKit
import Alamofire

struct GenericResponse: Codable {
   /*let Success: Bool
    let Message: String*/
}

struct DeadRequest {
    let latitude: Float
    let longitude: Float
    let datetime_event: String
    let temperature: Float
    let battery_percentage: Float
    let is_dead: Bool

}

class DeadLandViewController: UIViewController {

    @IBOutlet weak var buttonNewSimulation: UIButton!
    @IBOutlet weak var buttonSimulation: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: "FireCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "FireCollectionViewCell")
        self.collectionView.isHidden = true
        
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
        )
        self.mapView.mapType = .satellite
        self.mapView.setRegion(initialRegion, animated: false)
        self.mapView.isUserInteractionEnabled = false
        self.buttonNewSimulation.isHidden = true

    }
    @IBAction func actionNewSimuation(_ sender: Any) {
        self.navigationController?.setViewControllers([DeadLandViewController()], animated: true)
    }
    
    @IBAction func actionStartSimulation(_ sender: Any) {
        let targetRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 28.763964, longitude: -102.214111),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        self.mapView.setRegion(targetRegion, animated: true)
        
        let waitTime = 1.5
        let timer = Timer(timeInterval: waitTime, target: self, selector: #selector(loadTimer), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func loadTimer() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.isHidden = false
            self.buttonSimulation.setTitle("SIMULATION ACTIVE", for: .normal)
            self.buttonNewSimulation.isHidden = false
        }
    }
    
}

extension DeadLandViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FireCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FireCollectionViewCell", for: indexPath) as! FireCollectionViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/6, height: self.collectionView.frame.height/6)
    }
    
    func boomSelected(indexPath: IndexPath?, controller: FireCollectionViewCell) {
        controller.isDead = !controller.isDead

        controller.startBlinking(imageSensor: controller.imageSensor)
        if let indexPath = indexPath {
            self.addDeadSesor(latitude: Float(indexPath.row % 6 + 1), longitude: Float(indexPath.row / 6 + 1), dead: controller.isDead)
        }
    }
    
    func addDeadSesor(latitude: Float, longitude: Float, dead: Bool){
        let request = DeadRequest(latitude: latitude, longitude: longitude, datetime_event: getCurrentDate(), temperature: generateTemperature(), battery_percentage: generateBaterryPercentage(), is_dead: dead)
        print(request)
        
        let completion: LSResponseCompletionNoBase<GenericResponse> = { response in
            switch response {
            case .success(let lsresponse):
                break
            case .failure(_):
              break
            }
        }
        API.sendDeadSensor(dead: request).resumeJSON(completion: completion)
    }
    
    func generateTemperature() -> Float {
        let lowerBound = 400
        let upperBound = 1000
        let randomInt = Int(arc4random_uniform(UInt32(upperBound - lowerBound + 1))) + lowerBound
        return Float(randomInt)
    }
    
    func generateBaterryPercentage() -> Float {
        let randomInt = Int(arc4random_uniform(100)) + 1
        return Float(randomInt)
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
}
