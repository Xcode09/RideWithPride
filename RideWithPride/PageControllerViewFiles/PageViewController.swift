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
    var pageControll : UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource=self
        self.delegate = self
        ConfigurePageControll()
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
    
    private func ConfigurePageControll(){
        pageControll = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControll.numberOfPages = viewcontrollers.count
        self.pageControll.currentPage = 0
        self.pageControll.tintColor = UIColor.black
        self.pageControll.pageIndicatorTintColor = UIColor.white
        self.pageControll.currentPageIndicatorTintColor = UIColor.black
        self.pageControll.updateCurrentPageDisplay()
        self.view.addSubview(pageControll)
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.pageControll.currentPage = (viewControllers?.index(of: pageViewController.viewControllers![0]))!
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let beforeViewcontroller = viewcontrollers.index(of: viewController) else{ return nil}
        let periousviewcontrollerIndex = beforeViewcontroller - 1
        self.pageControll.currentPage = periousviewcontrollerIndex
        guard periousviewcontrollerIndex >= 0 else{
            self.pageControll.currentPage=0
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
        self.pageControll.currentPage = AfterViewcontroller
        guard AfterviewcontrollerIndex >= 0 else{
            self.pageControll.currentPage = 0
            return nil
        }
        guard viewcontrollers.count != AfterviewcontrollerIndex else{
            return nil
        }
        return viewcontrollers[AfterviewcontrollerIndex]
    }
    
}
