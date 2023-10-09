//
//  SOSViewController.swift
//  communityaerial
//
//  Created by Lisette HG on 08/10/23.
//

import UIKit
import AVFoundation

class SOSViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var turnOFf: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let audioPath = Bundle.main.path(forResource: "SOSSOS", ofType: "mp3") {
           let audioURL = URL(fileURLWithPath: audioPath)

           do {
               audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
               audioPlayer?.prepareToPlay()
               self.audioPlayer?.delegate = self
           } catch {
               print("Error al crear el reproductor de audio: \(error.localizedDescription)")
           }
       }
        
       // self.startBlinking()
        self.toggleAudio()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            player.currentTime = 0
            player.play()
        }
    }

    
    func startBlinking() {
           UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
               self.view.backgroundColor = UIColor.red
               self.view.backgroundColor = UIColor.red
           }, completion: nil)
       }
    
    func toggleAudio() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
    }

    @IBAction func actionTurnOff(_ sender: Any) {
        self.toggleAudio()
        self.navigationController?.popViewController(animated: true)
    }
    

}
