//
//  MainNoNIBViewController.swift
//  ISScrollViewPage
//
//  Created by Daniel Amaral on 19/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

class MainNoNIBViewController: UIViewController, ISScrollViewPageDelegate {

    var scrollViewPage:ISScrollViewPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.scrollViewPage!.scrollViewPageDelegate = self
        
        
    }

    
    override func loadView() {
        self.scrollViewPage = ISScrollViewPage(frame: UIScreen.mainScreen().applicationFrame)
        
        self.scrollViewPage!.setEnableBounces(false)
        self.scrollViewPage!.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageVertically
        
        
        var controllers = [FirstViewController(nibName:"FirstViewController",bundle:nil),
            SecondViewController(nibName:"SecondViewController",bundle:nil),
            ThirdViewController(nibName:"ThirdViewController",bundle:nil)]
        
        self.scrollViewPage!.setViewControllers(controllers)
        
        self.view = self.scrollViewPage
        
    }
    
    func scrollViewPageDidChanged(scrollViewPage: ISScrollViewPage, index: Int) {
        println("index : \(index)")
    }


}
