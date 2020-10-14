//
//  ViewController.swift
//  Example
//
//  Created by Chi Hoang on 30/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import UIKit
import CircularTimer

class ViewController: UIViewController {
    @IBOutlet weak var circularTimerView: CircularTimerView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circularTimerView.duration = 20.0
        circularTimerView.setupCircularTimer()
        circularTimerView.startCountDownTime()
    }
}
