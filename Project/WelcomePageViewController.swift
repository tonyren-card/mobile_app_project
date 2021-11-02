//
//  WelcomePageViewController.swift
//  iosCard
//
//  Created by Tony Ren on 2021-11-02.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController {
    
    var pageHeadings = ["Getting Started", "Search Page", "Car in a Card", "All Set"]
    var pageContent = ["A", "B", "C", "D"]
    var pageImages = ["Welcome_1", "Welcome_2", "Welcome_3", "Welcome_4"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        //create first welcome screen
        if let startingViewController = viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> WelcomeContentViewController? {
        
        // If invalid/OOB
        if index == NSNotFound || index < 0 || index >= self.pageHeadings.count {
            return nil
        }
        
        //Navigate
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeContentViewController") as? WelcomeContentViewController {
            
            pageContentViewController.heading = self.pageHeadings[index]
            pageContentViewController.content = self.pageContent[index]
            pageContentViewController.imageFile = self.pageImages[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
    
    func forward(_ index: Int) {
        if let nextViewController = viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    //Go back
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WelcomeContentViewController).index
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    //Go forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WelcomeContentViewController).index
        index += 1
        return viewControllerAtIndex(index)
    }
    
}
