//
//  PageViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 05/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    lazy var viewcontrollers: [UIViewController]={
       return [
        self.storyboardsViewcontroller(indentifer: "Ridervc"),
        self.storyboardsViewcontroller(indentifer: "Drivervc")
        ]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource=self
        self.delegate = self
        if let fristvc = viewcontrollers.first{
            setViewControllers([fristvc], direction: .forward, animated: true, completion: nil)
        }
        
       
    }
    /// Mark: instantiateViewController
    
    private func storyboardsViewcontroller(indentifer:String)->
        UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: indentifer)
            return storyboard
    }
    /// Mark : pageControllForDots
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let beforeViewcontroller = viewcontrollers.index(of: viewController) else{ return nil}
        let periousviewcontrollerIndex = beforeViewcontroller - 1
        
        guard periousviewcontrollerIndex >= 0 else{
            
            return nil
        }
        guard viewcontrollers.count > periousviewcontrollerIndex else{
            return nil
        }
        return viewcontrollers[periousviewcontrollerIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let AfterViewcontroller = viewcontrollers.index(of: viewController) else{ return nil}
        let AfterviewcontrollerIndex = AfterViewcontroller + 1
        
        guard AfterviewcontrollerIndex >= 0 else{
            
            return nil
        }
        guard viewcontrollers.count != AfterviewcontrollerIndex else{
            return nil
        }
        return viewcontrollers[AfterviewcontrollerIndex]
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
