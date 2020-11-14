//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!
  
  let eggTimes = ["Soft":3, "Medium":4, "Hard":7]
  
  var timer = Timer()
  var totalTime = 0
  var secondsPassed = 0
  
  var player : AVAudioPlayer?
  
  @IBAction func hardnessSelected(_ sender: UIButton) {
    timer.invalidate()
    progressBar.progress = 0.0
    secondsPassed = 0
    let hardness = sender.currentTitle!
    titleLabel.text = hardness
    
    totalTime = eggTimes[hardness]!
  
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
  }
  
  @objc func updateTimer() {
    if secondsPassed < totalTime {
      secondsPassed += 1
      progressBar.progress = Float(secondsPassed) / Float(totalTime)

    } else {
      timer.invalidate()
      
      guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

      do {
          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
          try AVAudioSession.sharedInstance().setActive(true)

          player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

          guard let player = player else { return }

          player.play()

      } catch let error {
          print(error.localizedDescription)
      }
      
      
      titleLabel.text = "Done!"
    }
  }
}
