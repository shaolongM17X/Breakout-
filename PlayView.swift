//
//  PlayView.swift
//  Breakout!
//
//  Created by Shaolong Lin on 7/29/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class PlayView: UIView, UICollisionBehaviorDelegate {
	private struct Constants {
		// Constants related to Bricks
		static let BricksPerRow = 8
		static let BrickRows = 6
		static let BrickHeight: CGFloat = 20
		static let TopOffset: CGFloat = 60
		static let BrickColor: UIColor = UIColor.redColor()
		// Constants related to Paddle
		static let BottomOffset: CGFloat = 30
		static let PaddleWidth: CGFloat = 60
		static let PaddleHeight: CGFloat = 10
		// Constants related to Ball
		static let BallRadius: CGFloat = 10
		// Constants with push behavior
		static let PushMagnitude: CGFloat = 0.2
	}
	
	private struct Identifiers {
		static let PaddleBoundaryIdentifier = "paddle boundary"
	}
	
	func initializeGame() {
		prepareForBircks()
		preparePaddle()
		prepareTheBall()
	}
	
	func pauseGame() {
		behavior.pauseGame(itemNeedsToBePaused: ballView)
	}
	
	func continueGame() {
		behavior.continueGame(itemNeedsToBePaused: ballView)
	}
	
	// behavior and animator
	private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
	var animating = false {
		didSet {
			if animating {
				animator.addBehavior(behavior)
			} else {
				animator.removeBehavior(behavior)
			}
		}
	}
	
	
	private lazy var behavior: BreakoutBehavior = {
		let behavior = BreakoutBehavior()
		behavior.collider.collisionDelegate = self
		
		return behavior
	}()
	
	
	func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
		if let id = identifier as? String {
			if id.rangeOfString("brick") != nil {
				if let brick = bricks[id] {
					UIView.animateWithDuration(
						0.3,
						delay: 0.0,
						options: [UIViewAnimationOptions.CurveLinear],
						animations: {
							brick.alpha = CGFloat(0.0)
						},
						completion: {
							if $0 {
								brick.removeFromSuperview()
							}
						})
					behavior.removeBoundaryWithIdentifier(id)
				}
			}
		} else {
			// we hit one of the boundary.
			if ballView.frame.maxY > paddleY {
				print("Sb")
			}
 		}
	}
	
	// ball view
	private var ballSize: CGSize {
		return CGSize(width: Constants.BallRadius * 2, height: Constants.BallRadius * 2)
	}
	private var ballView: UIView!
	func prepareTheBall() {
		let frame = CGRect(origin: CGPoint(x: bounds.midX, y: bounds.midY), size: ballSize)
		ballView = UIView(frame: frame)
		ballView.layer.cornerRadius = frame.width / 2
		ballView.backgroundColor = UIColor.blackColor()
		addSubview(ballView)
		behavior.addBall(ballView)
	}
	
	// brick view 
	private var bricks = [String: UIView]()
	private var brickWidth: CGFloat {
		return bounds.size.width / CGFloat(Constants.BricksPerRow)
	}
	private var brickSize: CGSize {
		return CGSize(width: brickWidth, height: Constants.BrickHeight)
	}
	
	
	func prepareForBircks() {
		for rowNumber in 0..<Constants.BrickRows {
			for colNumber in 0..<Constants.BricksPerRow {
				drawBrickAtPosition(CGFloat(colNumber) * brickWidth, y: Constants.TopOffset + CGFloat(rowNumber) * Constants.BrickHeight)
			}
		}
	}

	
	private func drawBrickAtPosition(x: CGFloat, y: CGFloat) {
		let frame = CGRect(origin: CGPoint(x: x,y: y), size: brickSize)
		let brick = UIView(frame: frame)
		
		
		brick.backgroundColor = Constants.BrickColor
		brick.layer.borderWidth = 1
		brick.layer.borderColor = UIColor.blackColor().CGColor
		addSubview(brick)
		
		let path = UIBezierPath(rect: frame)
		let identifier = "brick with x: \(x) and y: \(y)"
		behavior.addBarrier(path, named: identifier)
		bricks[identifier] = brick
	}
	
	// paddle
	private var paddleSize: CGSize {
		return CGSize(width: Constants.PaddleWidth, height: Constants.PaddleHeight)
	}
	private var paddleY: CGFloat {
		return bounds.size.height - Constants.BottomOffset
	}
	var paddle: UIView?
	func preparePaddle() {
		if paddle != nil {
			paddle!.removeFromSuperview()
		}
		let paddleOrigin = CGPoint(x: bounds.midX - (Constants.PaddleWidth)/2, y: paddleY)
		let frame = CGRect(origin: paddleOrigin, size: paddleSize)
		paddle = UIView(frame: frame)
		
		paddle!.backgroundColor = UIColor.darkGrayColor()
		paddle!.layer.borderWidth = 1
		paddle!.layer.borderColor = UIColor.blackColor().CGColor
		addSubview(paddle!)
		
		let path = UIBezierPath(rect: frame)
		behavior.addBarrier(path, named: Identifiers.PaddleBoundaryIdentifier)
	}
	private func updatePaddleBoundary(frame: CGRect) {
		let path = UIBezierPath(rect: frame)
		behavior.addBarrier(path, named: Identifiers.PaddleBoundaryIdentifier)
	}
	
	// Gesture:
	//		Drag
	func moveThePaddle(recognizer: UIPanGestureRecognizer) {
		var locationX = recognizer.locationInView(self).x - Constants.PaddleWidth / 2
		if locationX < 0 {
			locationX = 0
		} else if locationX + Constants.PaddleWidth > bounds.size.width {
			locationX = bounds.size.width - Constants.PaddleWidth
		}
		switch recognizer.state {
		case .Changed:
			
			paddle!.frame.origin = CGPoint(x: locationX, y: paddleY)
			updatePaddleBoundary(paddle!.frame)
		default:
			break
		}
	}
	//		Tap
	func pushTheBall(recognizer: UITapGestureRecognizer) {
		switch recognizer.state {
		case .Ended:
			addPushBehavior()
		default:
			break
		}
	}
	
	private func addPushBehavior() {
		let pushBehavior = UIPushBehavior(items: [ballView], mode: .Instantaneous)
		pushBehavior.magnitude = Constants.PushMagnitude
		pushBehavior.angle = CGFloat(-M_PI / 3)
		pushBehavior.action = { [unowned pushBehavior] in
			pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
		}
		animator.addBehavior(pushBehavior)
	}
	

	
}
