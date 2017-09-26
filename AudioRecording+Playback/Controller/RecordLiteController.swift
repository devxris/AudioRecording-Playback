//
//  RecordLiteController.swift
//  AudioRecording+Playback
//
//  Created by Chris Huang on 26/09/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordLiteController: UIViewController {
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	var audioRecorder: AVAudioRecorder?
	var audioPlayer: AVAudioPlayer?
	
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopbutton: UIButton!
	
	private func prepareAudioRecorder() {
		// Get document directory
		guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			let alert = UIAlertController(title: "Error", message: "Failed to get the document directory for recording the audio. Please try again later.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
		
		// Set default audio file URL
		let audioFileURL = documentURL.appendingPathComponent("AudioDemo.m4a")
		
		// Setup audio session
		let audioSession = AVAudioSession.sharedInstance()
		
		do {
			// Set audioSession category
			try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
			// Define the recorder setting
			let recorderSetting: [String: Any] = [
				AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
				AVSampleRateKey: 44100.0,
				AVNumberOfChannelsKey: 2,
				AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
			]
			// Configure and prepare the recorder
			audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
			audioRecorder?.delegate = self
			audioRecorder?.isMeteringEnabled = true
			audioRecorder?.prepareToRecord()
			
		} catch {
			print(error)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		playButton.isEnabled = false
		stopbutton.isEnabled = false
		prepareAudioRecorder()
	}
	
	@IBAction func record(_ sender: UIButton) {
		// Stop the audio player before recording
		if let player = audioPlayer, player.isPlaying { player.stop() }
		guard let recorder = audioRecorder else { return }
		if !recorder.isRecording {
			let audioSession = AVAudioSession.sharedInstance()
			do {
				// set audioSession to active
				try audioSession.setActive(true) // a must do trick
				// start recording
				recorder.record()
				// set recordButton to pauseButton
				recordButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
			} catch {
				print(error)
			}
		} else {
			recorder.pause()
			recordButton.setImage(#imageLiteral(resourceName: "Record"), for: .normal)
		}
		stopbutton.isEnabled = true
		playButton.isEnabled = false
	}
	
	@IBAction func play(_ sender: UIButton) {
	}
	
	@IBAction func stop(_ sender: UIButton) {
	}
}

extension RecordLiteController: AVAudioRecorderDelegate {
	
}

