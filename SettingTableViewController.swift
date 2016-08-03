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
		
    }

	@IBOutlet weak var bricksPerRowLabel: UILabel!
	private var bricksPerRowValue = Constants.BricksPerRow {
		willSet {
			Constants.BricksPerRow = newValue
			Constants.ViewNeedsUpdate = true
		}
	}
	@IBOutlet weak var bricksRowLabel: UILabel!
	private var bricksRowValue = Constants.BrickRows {
		willSet {
			Constants.BrickRows = newValue
			Constants.ViewNeedsUpdate = true
		}
	}
	@IBOutlet weak var bricksHeightLabel: UILabel!
	private var bricksHeightValue = Constants.BrickHeight {
		willSet {
			Constants.BrickHeight = newValue
			Constants.ViewNeedsUpdate = true
		}
	}

	@IBOutlet weak var ballRadiusLabel: UILabel!
	private var ballRadiusValue = Constants.BallRadius {
		willSet {
			Constants.BallRadius = newValue
			Constants.BallNeedsUpdate = true
		}
	}

	@IBOutlet weak var gravityValueForBall: UILabel!
	private var ballGravityValue = Constants.GravityForBall {
		willSet {
			Constants.GravityForBall = newValue
			Constants.PushMagnitude = newValue / 3
			Constants.BallNeedsUpdate = true
		}
	}

	
	

	// used by steepers to update label's value
	@IBAction func increaseValue(sender: UIStepper) {
		let newValue = Int(sender.value)
		switch sender.tag {
		case 0:
			bricksPerRowLabel.text = String(newValue)
			bricksPerRowValue = newValue
		case 1:
			bricksRowLabel.text = String(newValue)
			bricksRowValue = newValue
		case 2:
			bricksHeightLabel.text = String(newValue)
			bricksHeightValue = CGFloat(newValue)
		case 3:
			ballRadiusLabel.text = String(newValue)
			ballRadiusValue = CGFloat(newValue)
		default:
			break
		}
	}

	@IBAction func increaseGravityForBall(sender: UISlider) {
		sender.value = round(sender.value * 100) / 100
		gravityValueForBall.text = String(sender.value)
		ballGravityValue = CGFloat(sender.value)
	}
	
	@IBAction func changeBricksColor(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			Constants.BrickColor = UIColor.redColor()
		case 1:
			Constants.BrickColor = UIColor.yellowColor()
		case 2:
			Constants.BrickColor = UIColor.blueColor()
		default:
			Constants.BrickColor = UIColor.redColor()
		}
		Constants.ViewNeedsUpdate = true
	}
	
	@IBAction func changeBallColor(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			Constants.BallColor = UIColor.blackColor()
		default:
			Constants.BallColor = UIColor.getRandomColor()
		}
	}
	@IBAction func changeBricksColliderBehavior(sender: UISwitch) {
		Constants.BrickAsCollider = sender.on
		Constants.ViewNeedsUpdate = true
	}
	@IBOutlet weak var bricksAsColliderSwitch: UISwitch!
	@IBAction func changeBricksGravityBehavior(sender: UISwitch) {
		Constants.BrickAffectedByGravity = sender.on
		Constants.ViewNeedsUpdate = true
	}
	

}
