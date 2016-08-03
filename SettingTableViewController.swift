//
//  SettingTableViewController.swift
//  Breakout!
//
//  Created by Shaolong Lin on 8/2/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		labels = [
			0: bricksPerRowLabel,
			1: bricksRowLabel,
			2: bricksHeightLabel,
			3: ballRadiusLabel
		]
    }

	@IBOutlet weak var bricksPerRowLabel: UILabel!
	@IBOutlet weak var bricksRowLabel: UILabel!
	@IBOutlet weak var bricksHeightLabel: UILabel!
	@IBOutlet weak var ballRadiusLabel: UILabel!
	@IBOutlet weak var gravityValueForBall: UILabel!
	
	private var labels: [Int: UILabel]?
	
	private var bricksPerRow: CGFloat? {
		set {
			
		}
		
		get {
			return CGFloat(Int(bricksPerRowLabel.text!)!)
		}
	}

	// used by steepers to update label's value
	@IBAction func increaseValue(sender: UIStepper) {
		labels?[sender.tag]?.text = String(Int(sender.value))
	}
	// used by slider to increase gravity value
	@IBAction func increaseGravityForBall(sender: UISlider) {
		sender.value = round(sender.value * 100) / 100
		gravityValueForBall.text = String(sender.value)
	}

	

}
