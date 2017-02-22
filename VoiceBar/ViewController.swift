//
//  ViewController.swift
//  VoiceBar
//
//  Created by Cameron Reid on 21/02/2017.
//  Copyright © 2017 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	
	@IBOutlet weak var barView: BarView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		barView.start()
	}
	
}

