//
//  File.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 27/09/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
@IBDesignable
class ButtonX:UIButton{
    
    @IBInspectable var first:UIColor = UIColor.clear{
        didSet{
            update()
        }
    }
     @IBInspectable var second:UIColor = UIColor.clear{
        didSet{
            update()
        }
    }
    override class var layerClass : AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    func update(){
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 1.1)
        layer.colors = [first.cgColor,second.cgColor]
        
    }
}
