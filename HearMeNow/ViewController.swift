//
//  ViewController.swift
//  HearMeNow
//
//  Created by user131309 on 12/14/17.
//  Copyright © 2017 Patricia Toles. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var hasRecording = false             //Determines whether a recording has been made
    var soundPlayer: AVAudioPlayer?      //Handles all audio playback
    var soundRecorder: AVAudioRecorder?  //Handles recording from the microphone
    var session: AVAudioSession!       //Activates and deactivates the audio session
    var soundPath: String?  //Holds the path for the recorded file
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordPressed(_ sender: Any) {
        if(soundRecorder?.isRecording == true)
        {
            soundRecorder?.stop()
            recordButton.setTitle("Record", for: UIControlState.normal)
            hasRecording=true
        }
        else {
            session.requestRecordPermission(){
                granted in
                if(granted == true) {
                self.soundRecorder?.record()
                self.recordButton.setTitle("Stop", for:UIControlState.normal)
            } else {
                
                print("Unable to record")
            }
        }
    }
    
    }
    
    @IBAction func playPressed(_ sender: Any) {
        if(soundPlayer?.isPlaying == true) {
            soundPlayer?.pause()
            playButton.setTitle("Play", for: UIControlState.normal)
        }
        else if (hasRecording == true) {
            let url = URL(fileURLWithPath: soundPath!)
            do {
                try soundPlayer = AVAudioPlayer(contentsOf: url)
                soundPlayer?.delegate = self
                soundPlayer?.play()
            } catch {
                print("Error initializing player(error)")
                
            }
                playButton.setTitle("Pause", for: UIControlState.normal)
                hasRecording = false
        }
        else if (soundPlayer != nil) {
                soundPlayer?.play()
                playButton.setTitle("Pause", for: UIControlState.normal)
                
            }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordButton.setTitle("Record", for: UIControlState.normal)
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: UIControlState.normal)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        session = AVAudioSession.sharedInstance()
        do {
            soundPath = "\(NSTemporaryDirectory()) hearmenow.m4a"
            let url = URL(fileURLWithPath: soundPath!)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try
                session.setActive(true);
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000.0,
                            AVNumberOfChannelsKey: 1 as NSNumber,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
            try
                soundRecorder = AVAudioRecorder(url: url, settings: settings)
            soundRecorder?.delegate = self
            soundRecorder?.prepareToRecord()
        }
        
        catch {
            print(error)
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

