//
//  ISScrollViewPageController.swift
//  ISScrollViewPageController
//
//  Created by Daniel Amaral on 11/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

enum ISScrollViewPageType {
    case ISScrollViewPageHorizontally, ISScrollViewPageVertically
}

protocol ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(scrollViewPage:ISScrollViewPage,index:Int);
}

class ISScrollViewPage: UIScrollView, UIScrollViewDelegate {
    
    var viewControllers:[UIViewController]?
    var scrollViewPageDelegate:ISScrollViewPageDelegate?
    var lastIndex = 0
    var enableBouces:Bool?
    var scrollViewPageType:ISScrollViewPageType?
    
    //MARK: Life Cycle
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initScrollView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initScrollView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout(scrollViewPageType!)
    }
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var result:Int
        var index:Int
        
        switch (self.scrollViewPageType!) {
            
        case .ISScrollViewPageHorizontally:
            
            var frame = self.frame.width
            
            if contentOffset.x != 0 {
                index = Int(self.contentOffset.x / frame)
            }else{
                index = 0;
            }
            
        case .ISScrollViewPageVertically:
        
            var frame = self.frame.height
            
            if contentOffset.y != 0 {
                index = Int(self.contentOffset.y / frame)
            }else{
                index = 0;
            }
            
        }
        
        if index != lastIndex {
            scrollViewPageDelegate!.scrollViewPageDidChanged(self, index: index)
        }
        
        lastIndex = index
        
    }
    
    
    //MARK: Public Functions
    
    func goToIndex(index:Int, animated:Bool){
        
        if index >= self.viewControllers!.count{
            
            UIAlertView(title: "", message: "Index \(index) doesn't has any view controller", delegate: self, cancelButtonTitle: "OK").show()
            
            return
        }
        
        switch(self.scrollViewPageType!){
            
        case .ISScrollViewPageHorizontally:
            
            var frameWidth = Int(self.frame.width)
            var widthOfContentOffset = index * frameWidth
            
            self.setContentOffset(CGPointMake(CGFloat(widthOfContentOffset), 0), animated: animated)
            
        case .ISScrollViewPageVertically:
            
            var frameHeight = Int(self.frame.height)
            var heightOfContentOffset = index * frameHeight
            
            self.setContentOffset(CGPointMake(0, CGFloat(heightOfContentOffset)), animated: animated)
            
        }
        
        if index != lastIndex {
            scrollViewPageDelegate!.scrollViewPageDidChanged(self, index: index)
        }        
        
        lastIndex = index
        
    }
    
    func setViewControllers(viewControllers:[UIViewController]){
        self.viewControllers! = viewControllers;
    }

    func setEnableBounces(enableBounces:Bool){
        self.bounces = enableBounces
    }
    
    //MARK: Private Functions
    
    private func initScrollView() {
        super.delegate = self
        self.viewControllers = []
        self.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageHorizontally
    }
    
    private func setupLayout (scrollViewPageType:ISScrollViewPageType){
        
        var frame:CGRect = self.frame
        
        for i in 0...self.viewControllers!.count-1 {

            var viewController = self.viewControllers![i]
            
            viewController.view.frame = self.frame
            
            var view:UIView = UIView()
            
            switch (scrollViewPageType) {
                
                case .ISScrollViewPageHorizontally:
                    
                    frame.origin.x = CGFloat(self.frame.size.width * CGFloat(i));
                    frame.size = self.frame.size
                    frame.origin.y = 0
                    
                    self.contentSize = CGSizeMake(self.frame.size.width * CGFloat(self.viewControllers!.count), self.frame.size.height)
                    
                case .ISScrollViewPageVertically:
                    frame.origin.y = CGFloat(self.frame.size.height * CGFloat(i));
                    frame.size = self.frame.size
                    frame.origin.x = 0
                    
                    self.contentSize = CGSizeMake(self.frame.size.width,self.frame.size.height * CGFloat(self.viewControllers!.count))
                }
            
            view.frame = frame
            
            view.addSubview(viewController.view)            
            
            self.addSubview(view)
            
        }
        
        self.pagingEnabled = true
        
    }
    
}
