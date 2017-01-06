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
        self.scrollViewPage = ISScrollViewPage(frame: UIScreen.main.applicationFrame)
        
        self.scrollViewPage!.setEnableBounces(false)
        self.scrollViewPage!.scrollViewPageType = ISScrollViewPageType.vertically
        
        
        let controllers = [FirstViewController(nibName:"FirstViewController",bundle:nil),
            SecondViewController(nibName:"SecondViewController",bundle:nil),
            ThirdViewController(nibName:"ThirdViewController",bundle:nil)]
        
        self.scrollViewPage!.setControllers(controllers)
        
        self.view = self.scrollViewPage
        
    }
    
    func scrollViewPageDidChanged(_ scrollViewPage: ISScrollViewPage, index: Int) {
        print("index : \(index)")
    }


}
