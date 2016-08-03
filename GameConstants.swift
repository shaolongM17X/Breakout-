//
//  GameConstants.swift
//  Breakout!
//
//  Created by Shaolong Lin on 8/2/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

struct Constants {
	// Constants that doesn't change
	static let TopOffset: CGFloat = 60
	static let BottomOffset: CGFloat = 30
	static let PaddleWidth: CGFloat = 60
	static let PaddleHeight: CGFloat = 10
	// Constants related to Bricks
	static var BricksPerRow = 5
	static var BrickRows = 3
	static var BrickHeight: CGFloat = 20
	static var BrickColor: UIColor = UIColor.redColor()
	static var BrickAsCollider = false
	static var BrickAffectedByGravity = false
	// Constants related to Ball
	static var BallRadius: CGFloat = 10
	static var BallColor: UIColor = UIColor.blackColor()
	static var GravityForBall: CGFloat = 0.1
	// Constants with push behavior
	static var PushMagnitude: CGFloat = 0.2
	
	// flag showing whether or not we should update the view
	static var ViewNeedsUpdate: Bool = false
	static var BallNeedsUpdate: Bool = false
}

extension UIColor {
	class func getRandomColor() -> UIColor {
		let randomRed:CGFloat = CGFloat(drand48())
		let randomGreen:CGFloat = CGFloat(drand48())
		let randomBlue:CGFloat = CGFloat(drand48())
		return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)	
	}
}
