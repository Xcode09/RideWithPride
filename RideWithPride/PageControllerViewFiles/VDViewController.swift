//
//  VDViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 05/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit

class VDViewController: UIViewController {
    @IBOutlet weak var button : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = CGColor.colorForbtn()
    }

}
