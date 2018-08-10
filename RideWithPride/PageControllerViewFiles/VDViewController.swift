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
        let image = UIImageView().CreateImageView(Image: "Taxi2")
        super.viewDidLoad()
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = CGColor.colorForbtn()
        self.view.insertSubview(image, at: 0)
        image.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        image.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        image.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
    }

}
