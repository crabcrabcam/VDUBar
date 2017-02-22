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
	@IBOutlet weak var barView2: BarView2!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		barView.start()
		barView2.start()
	}
	
}

