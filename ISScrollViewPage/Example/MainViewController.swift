//
//  MainViewController.swift
//  ISScrollViewPage
//
//  Created by Daniel Amaral on 12/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController , ISScrollViewPageDelegate{

    @IBOutlet weak var scrollViewPage:ISScrollViewPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollViewPage.scrollViewPageDelegate = self;
        self.scrollViewPage.setEnableBounces(false)
        self.scrollViewPage.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageVertically
        
        
        var controllers = [FirstViewController(nibName:"FirstViewController",bundle:nil),
            SecondViewController(nibName:"SecondViewController",bundle:nil),
            ThirdViewController(nibName:"ThirdViewController",bundle:nil)]
        
        self.scrollViewPage.setViewControllers(controllers)
        
        
    }

    func scrollViewPageDidChanged(scrollViewPage: ISScrollViewPage, index: Int) {
        println("You are at index: \(index)")
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        
        var button = sender as UIButton
        
        switch (button.tag) {
            
        case 0:
            self.scrollViewPage.goToIndex(0, animated: true)
            
        case 1:
            self.scrollViewPage.goToIndex(1, animated: true)
            
        case 2:
            self.scrollViewPage.goToIndex(2, animated: true)
            
        default:
            break
            
        }
        
    }
    
}
