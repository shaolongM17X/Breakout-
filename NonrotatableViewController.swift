//
//  NonrotatableViewController.swift
//  Breakout!
//
//  Created by Shaolong Lin on 7/29/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class NonrotatableViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 
	override func shouldAutorotate() -> Bool {
		return false
	}

}
