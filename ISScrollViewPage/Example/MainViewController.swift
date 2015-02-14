//
//  MainViewController.swift
//  ISScrollViewPage
//
//  Created by Daniel Amaral on 12/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController , ISScrollViewPageDelegate{

    @IBOutlet weak var scrollView:ISScrollViewPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.scrollViewPageDelegate = self;
        scrollView.setEnableBounces(false)
        scrollView.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageHorizontally
        
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        var controllers = [FirstViewController(nibName:"FirstViewController",bundle:nil),
                           SecondViewController(nibName:"SecondViewController",bundle:nil),
                           ThirdViewController(nibName:"ThirdViewController",bundle:nil)]
        
        self.scrollView.setViewControllers(controllers)
        
        
        
    }
    
    func scrollViewPageDidChanged(scrollViewPage: ISScrollViewPage, index: Int) {
        println("You are at index: \(index)")
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        
        var button = sender as UIButton
        
        switch (button.tag) {
            
        case 1:            
            scrollView.goToIndex(0, animated: true)
            break
            
        case 2:
            scrollView.goToIndex(1, animated: true)
            break
            
        case 3:
            scrollView.goToIndex(2, animated: true)
            break
            
        default:
            break
            
        }
        
    }
    
}
