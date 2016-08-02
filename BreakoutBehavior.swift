//
//  BreakoutBehavior.swift
//  Breakout!
//
//  Created by Shaolong Lin on 7/31/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
	private let gravity: UIGravityBehavior = {
		let gravity = UIGravityBehavior()
		gravity.magnitude = 0.1
		return gravity
	}()
	let collider: UICollisionBehavior = {
		let collider = UICollisionBehavior()
		collider.translatesReferenceBoundsIntoBoundary = true
		return collider
	}()
	private let ballItemBehavior: UIDynamicItemBehavior = {
		let dib = UIDynamicItemBehavior()
		dib.elasticity = 1
		dib.allowsRotation = false
		return dib
	}()
	
	func addBall(ball: UIDynamicItem) {
		gravity.addItem(ball)
		collider.addItem(ball)
		ballItemBehavior.addItem(ball)
	}
	
	func removeBall(ball: UIDynamicItem) {
		gravity.removeItem(ball)
		collider.removeItem(ball)
		ballItemBehavior.removeItem(ball)
	}
	
	// dealing with pausing and continuing game
	private var ballLinearVelocity: CGPoint?
	private var ballAngularVelocity: CGFloat?
	
	func pauseGame(itemNeedsToBePaused item: UIDynamicItem) {
		removeChildBehavior(gravity)
		ballLinearVelocity = ballItemBehavior.linearVelocityForItem(item)
		ballAngularVelocity = ballItemBehavior.angularVelocityForItem(item)
		let negativeVelocity = CGPoint(x: -ballLinearVelocity!.x, y: -ballLinearVelocity!.y)
		let negativeAngularVelocity = -ballAngularVelocity!
		ballItemBehavior.addLinearVelocity(negativeVelocity, forItem: item)
		ballItemBehavior.addAngularVelocity(negativeAngularVelocity, forItem: item)
	}
	func continueGame(itemNeedsToBeContinued item: UIDynamicItem) {
		if let velocity = ballLinearVelocity, angularVelocity = ballAngularVelocity {
			addChildBehavior(gravity)
			ballItemBehavior.addLinearVelocity(velocity, forItem: item)
			ballItemBehavior.addAngularVelocity(angularVelocity, forItem: item)
			
		}
	}
	
	override init() {
		super.init()
		addChildBehavior(gravity)
		addChildBehavior(collider)
		addChildBehavior(ballItemBehavior)
	}
	
	func addBarrier(path: UIBezierPath, named name: String) {
		collider.removeBoundaryWithIdentifier(name)
		collider.addBoundaryWithIdentifier(name, forPath: path)
	}

}
