//
//  BarView.swift
//  VoiceBar
//
//  Created by Cameron Reid on 21/02/2017.
//  Copyright © 2017 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit

class BarView: UIView {


	var bar: CAGradientLayer!
	var layerMask: CALayer!
	var timer: Timer!
	var label: UITextField!
	let minDecibels: Float = -80
	public var updated: ((Float) -> Void)?
	
	var mic: AKMicrophone!
	var tracker: AKAmplitudeTracker!
	var silence: AKBooster!
	var boost: AKBooster!
	
	var level: Float {
//		print((Float(tracker.amplitude)))
		return Float(Double(20) * log10(tracker.amplitude))
	}
	
	var pos: Float {
		
		let decibels = level
		
		if decibels < minDecibels {
			return 0
		} else if decibels >= 0 {
			return 1
		}
		
		let minAmp = powf(10, 0.05 * minDecibels)
		let inverseAmpRange = 1 / (1 - minAmp)
		let amp = powf(10, 0.05 * decibels)
		let adjAmp = (amp - minAmp) * inverseAmpRange
//		let sqrtAdjAmp = sqrtf(adjAmp)
		return sqrt(adjAmp)
		
//		return (sqrtAdjAmp * 130) + 20
	}
	
	func start() {
		
		AKSettings.audioInputEnabled = true
		
		mic = AKMicrophone()
		boost = AKBooster(mic, gain: 3)
		tracker = AKAmplitudeTracker.init(boost)
		
		silence = AKBooster(tracker, gain: 0)
		
		AudioKit.output = silence
		
		layer.backgroundColor = UIColor.black.cgColor
		
		addBar()
		addLabel()
		
		
		AudioKit.start()
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMeter), userInfo: nil, repeats: true)
	}

	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		start()
	}
	
	
	
	let settings: [String:Any] = [
		AVFormatIDKey: kAudioFormatLinearPCM,
		AVSampleRateKey: 44100,
		AVNumberOfChannelsKey: 1,
		AVLinearPCMBitDepthKey: 16,
		AVLinearPCMIsBigEndianKey: false,
		AVLinearPCMIsFloatKey: false
	]
		
		
	
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
//		fatalError("init(coder:) has not been implemented")
	}
	
	var audioSession = AVAudioSession.sharedInstance()
	
	
	func addLabel() {
		label = UITextField(frame: CGRect(x: 0, y: 50, width: 200, height: 50))
		label.textColor = UIColor.white
		label.font = UIFont.systemFont(ofSize: 24)
		label.allowsEditingTextAttributes = false
		label.text = "0dB"
		label.backgroundColor = UIColor.black
		addSubview(label)
	}
	
	func addBar() {
		
		layerMask = CALayer()
		layerMask.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
		layerMask.masksToBounds = true
		layer.addSublayer(layerMask)
		
		
		let color1 = UIColor(red:1.00, green:0.00, blue:0.80, alpha:1.0).cgColor
		let color2 = UIColor(red:0.20, green:0.20, blue:0.60, alpha:1.0).cgColor
		bar = CAGradientLayer()
		bar.startPoint = CGPoint(x: 0, y: 0)
		bar.endPoint = CGPoint(x: 1, y: 0)
		bar.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 50)
		bar.colors = [color2, color1]
		
		layerMask.addSublayer(bar)
	}
	
	
	func updateMeter() {
		updated?(level)
		label.text = "\(Int(level))dB"
		print(pos)
		layerMask.frame = CGRect(x: 0, y: 0, width: frame.size.width * CGFloat(pos), height: bar.bounds.size.height)
//		layerMask.frame = CGRect(x: 0, y: 0, width: frame.size.width * CGFloat(level), height: bar.bounds.size.height)
	}
	
}
