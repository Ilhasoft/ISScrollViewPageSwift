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
        self.scrollViewPage.setPaging(false)
        self.scrollViewPage.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageHorizontally
        
        
//        var controllers = [FirstViewController(nibName:"FirstViewController",bundle:nil),
//            SecondViewController(nibName:"SecondViewController",bundle:nil),
//            ThirdViewController(nibName:"ThirdViewController",bundle:nil)]
//        
//        self.scrollViewPage.setControllers(controllers)
        
        
        let view1:UIView = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor.yellowColor()
        
        let view2:UIView = UIView(frame: UIScreen.mainScreen().bounds)
        view2.backgroundColor = UIColor.greenColor()
        
        let view3:UIView = UIView(frame: UIScreen.mainScreen().bounds)
        view3.backgroundColor = UIColor.blackColor()
        
        self.scrollViewPage?.setCustomViews([view1,view2,view3])
        
    }

    func scrollViewPageDidChanged(scrollViewPage: ISScrollViewPage, index: Int) {
        print("You are at index: \(index)")
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        
        let button = sender as! UIButton
        
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
