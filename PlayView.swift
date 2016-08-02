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
		static let BricksPerRow = 1
		static let BrickRows = 1
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
	private var showingCoverView = true {
		didSet {
			if !showingCoverView {
				removeViewWithAnimation(coverView)
				removeViewWithAnimation(coverText)
				isPlaying = true
			} else {
				isPlaying = false
			}
		}
	}
	private var isPlaying = false {
		didSet {
			if isPlaying {
				animating = true
				continueGame()
			}
		}
	}
	private var gameOver = false {
		didSet {
			if gameOver {
				animating = false
				showCoverViewWithText("Oh oh..Touch to restart")
			} else {
				showingCoverView = false
				initializeGame()
			}
		}
	}
	private var winning = false {
		didSet {
			if winning {
				animating = false
				showCoverViewWithText("You win!")
			} else {
				showingCoverView = false
				initializeGame()
			}
		}
	}
	private var coverView: UIView!
	private var coverText: UILabel!
	private func showCoverViewWithText(textToDisplay: String) {
		showingCoverView = true
		coverView = UIView(frame: frame)
		coverView.backgroundColor = UIColor.blackColor()
		coverView.alpha = 0.85
		addSubview(coverView)
		coverText = UILabel()
		coverText.text = textToDisplay
		coverText.font = coverText.font?.fontWithSize(30)
		coverText.textColor = UIColor.whiteColor()
		coverText.sizeToFit()
		coverText.frame.origin = CGPoint(x: coverView.frame.midX - coverText.frame.width / 2, y: coverView.frame.midY - coverText.frame.height / 2)
		addSubview(coverText)
	}
	
	func initializeGame() {
		prepareForBricks()
		preparePaddle()
		prepareTheBall()
		animator.addBehavior(behavior)
		showCoverViewWithText("Touch to play")
	}
	
	func pauseGame() {
		if isPlaying {
			behavior.pauseGame(itemNeedsToBePaused: ballView)
			showCoverViewWithText("Pause")
		}
	}
	
	private func continueGame() {
		behavior.continueGame(itemNeedsToBeContinued: ballView)
	}
	
	// behavior and animator
	private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
	var animating = false {
		didSet {
			if animating {
				behavior.addBall(ballView)
			} else {
				behavior.removeBall(ballView)
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
					removeViewWithAnimation(brick)
					bricks.removeValueForKey(id)
					behavior.removeBoundaryWithIdentifier(id)
				}
				if bricks.count <= 0 {
					winning = true
				}
			}
		} else {
			// we hit one of the boundary.
			if ballView.frame.maxY > paddleY {
				gameOver = true
			}
 		}
	}
	
	// private method used to remove the brick with animation
	private func removeViewWithAnimation(view: UIView) {
		UIView.animateWithDuration(
			0.3,
			delay: 0.0,
			options: [UIViewAnimationOptions.CurveLinear],
			animations: {
				view.alpha = CGFloat(0.0)
			},
			completion: {
				if $0 {
					view.removeFromSuperview()
				}
		})
	}
	
	// ball view
	private var ballSize: CGSize {
		return CGSize(width: Constants.BallRadius * 2, height: Constants.BallRadius * 2)
	}
	private var ballView: UIView!
	func prepareTheBall() {
		if ballView != nil {
			ballView.removeFromSuperview()
			behavior.removeBall(ballView)
		}
		let frame = CGRect(origin: CGPoint(x: bounds.midX, y: bounds.midY), size: ballSize)
		ballView = UIView(frame: frame)
		ballView.layer.cornerRadius = frame.width / 2
		ballView.backgroundColor = UIColor.blackColor()
		addSubview(ballView)
	}
	
	// brick view 
	private var bricks = [String: UIView]()
	private var brickWidth: CGFloat {
		return bounds.size.width / CGFloat(Constants.BricksPerRow)
	}
	private var brickSize: CGSize {
		return CGSize(width: brickWidth, height: Constants.BrickHeight)
	}
	
	
	func prepareForBricks() {
		for rowNumber in 0..<Constants.BrickRows {
			for colNumber in 0..<Constants.BricksPerRow {
				drawBrickAtPosition(CGFloat(colNumber) * brickWidth, y: Constants.TopOffset + CGFloat(rowNumber) * Constants.BrickHeight)
			}
		}
	}

	
	private func drawBrickAtPosition(x: CGFloat, y: CGFloat) {
		let identifier = "brick with x: \(x) and y: \(y)"
		if bricks[identifier] == nil {
			let frame = CGRect(origin: CGPoint(x: x,y: y), size: brickSize)
			let brick = UIView(frame: frame)
			
			
			brick.backgroundColor = Constants.BrickColor
			brick.layer.borderWidth = 1
			brick.layer.borderColor = UIColor.blackColor().CGColor
			addSubview(brick)
			
			let path = UIBezierPath(rect: frame)
			
			behavior.addBarrier(path, named: identifier)
			bricks[identifier] = brick
		}
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
	func userTapScreen(recognizer: UITapGestureRecognizer) {
		if gameOver {
			gameOver = false
		} else if winning {
			winning = false
		} else {
			if showingCoverView {
				showingCoverView = false
			} else if isPlaying {
				pushTheBall(recognizer)
			}
		}
	}
	
	private func pushTheBall(recognizer: UITapGestureRecognizer) {
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
