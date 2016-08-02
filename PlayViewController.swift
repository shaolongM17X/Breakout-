//
//  PlayViewController.swift
//  Breakout!
//
//  Created by Shaolong Lin on 7/29/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	@IBOutlet weak var playView: PlayView! {
		didSet {
			playView.addGestureRecognizer(UIPanGestureRecognizer(target: playView, action: #selector(PlayView.moveThePaddle(_:))))
			playView.addGestureRecognizer(UITapGestureRecognizer(target: playView, action: #selector(playView.pushTheBall(_:))))
		}
	}
	
	
	private var initialize = true
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if initialize {
			playView.initializeGame()
			initialize = false
			playView.animating = true
		} else {
			playView.continueGame()
		}
		
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		playView.pauseGame()
	}
	
	
	
	

}
