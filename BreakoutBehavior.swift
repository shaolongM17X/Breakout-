//
//  BreakoutBehavior.swift
//  Breakout!
//
//  Created by Shaolong Lin on 7/31/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
	private let gravity = UIGravityBehavior()
	let collider: UICollisionBehavior = {
		let collider = UICollisionBehavior()
		collider.translatesReferenceBoundsIntoBoundary = true
		return collider
	}()
	private let itemBehavior: UIDynamicItemBehavior = {
		let dib = UIDynamicItemBehavior()
		dib.elasticity = 1
		return dib
	}()
	
	func addItemWithIdentifier(item: UIDynamicItem, withIdentifier identifier: String) {
		if identifier == Identifiers.BallIdentifier {
			gravity.addItem(item)
			collider.addItem(item)
			itemBehavior.addItem(item)
		} else {
			
		}
		
	}
	
	func removeItemWithIdentifier(item: UIDynamicItem, withIdentifier identifier: String) {
		if identifier == Identifiers.BallIdentifier {
			gravity.removeItem(item)
		}
		collider.removeItem(item)
	}
	
	override init() {
		super.init()
		addChildBehavior(gravity)
		addChildBehavior(collider)
		addChildBehavior(itemBehavior)
	}
	
	func addBarrier(path: UIBezierPath, named name: String) {
		collider.removeBoundaryWithIdentifier(name)
		collider.addBoundaryWithIdentifier(name, forPath: path)
	}
}
