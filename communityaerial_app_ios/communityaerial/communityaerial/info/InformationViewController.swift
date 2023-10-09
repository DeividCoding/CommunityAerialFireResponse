//
//  InformationViewController.swift
//  communityaerial
//
//  Created by Lisette HG on 07/10/23.
//

import UIKit
import AVFoundation
import Player
import youtube_ios_player_helper

struct Info {
    let title: String
    let url: String
    let image: String
}

class InformationViewController: ScrollViewController {
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var videoView: YTPlayerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var scrollContainer: UIScrollView? {
        return self.scrollView
    }
    
    var infoList: [Info] = []
    let player = Player()
    
    var timer: Timer?
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.videoView.backgroundColor = .black
        DispatchQueue.main.async {
            self.videoView.load(withVideoId: "ec9ILB8lQlo");
        }

        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: "InfoCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "InfoCollectionViewCell")
        
        self.infoList.append(Info(title: "What To do before a fire and how to prevent it?", url: "https://www.proteccioncivil.cdmx.gob.mx/storage/app/uploads/public/61f/184/cb4/61f184cb43402896280457.pdf", image: "info_uno"))
        self.infoList.append(Info(title: "My plot does not burn", url: "https://www.gob.mx/agricultura/acciones-y-programas/miparcelanosequema", image: "info_dos"))
        self.infoList.append(Info(title: "recommendations to avoid forest fires", url: "https://www.gob.mx/cenapred/articulos/cinco-recomendaciones-para-evitar-incendios-forestales#:~:text=Evita%20arrojar%20basura%2C%20materiales%20inflamables,ext%C3%ADnguelos%20con%20agua%20y%20tierra", image: "info_tres"))
        
        self.tips()
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(advanceToNextPage), userInfo: nil, repeats: true)

    }
    
    @objc func advanceToNextPage() {
        let nextPage = currentPage + 1

        if nextPage < collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: nextPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            currentPage = nextPage
        } else {
            let firstIndexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
            currentPage = 0
        }
    }

    
    func tips(){
        let tips = """
                    - Do not throw matches or lit cigarettes on the road, especially not in the middle of the forest.

                    - Do not litter; bottles or glass can start a fire by creating a magnifying glass effect with sunlight.

                    - Do not make campfires; no matter how many precautions you take, a flame can cause a large fire.

                    - Do not park cars on the roadside where there is dry grass.

                    - Do not leave anything flammable behind after camping.

                    - Do not start a fire in the wilderness if conditions are unfavorable.

                    - Store flammable liquids in protected areas.

                    - Do not accumulate garbage on the premises.

                    - Do not set fire to the land.

                    - Do not leave matches within children's reach.

                    - Extinguish the fire immediately; if you see a campfire or the start of a fire, surround it with green branches or douse it with water or soil.

                    - Seek help immediately if the fire gets out of control, get to safety, and notify authorities as soon as possible.

                    - Protect your life; when fleeing a fire, do not go uphill; look for flat areas and walk against the wind.

                    - In agricultural practices, if you use fire to clear the land for planting, create a firebreak to prevent it from spreading.
                    """


        self.labelDescription.text = tips
        self.labelTitle.text = self.labelTitle.text?.uppercased()
    }
}


extension InformationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.infoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as! InfoCollectionViewCell
        cell.labelTitle.text = self.infoList[indexPath.row].title.uppercased()
        cell.imageConainter.image = UIImage(named:  self.infoList[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: self.infoList[indexPath.row].url) {
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
    }
}


extension InformationViewController: PlayerPlaybackDelegate, PlayerDelegate {
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    

    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }

    public func playerPlaybackDidEnd(_ player: Player) {
    }

    public func playerCurrentTimeDidChange(_ player: Player) {
     //   let fraction = Double(player.currentTime) / Double(player.maximumDuration)
      //  self._playbackViewController?.setProgress(progress: CGFloat(fraction), animated: true)
    }

    public func playerPlaybackWillLoop(_ player: Player) {
       // self. _playbackViewController?.reset()
    }

}
