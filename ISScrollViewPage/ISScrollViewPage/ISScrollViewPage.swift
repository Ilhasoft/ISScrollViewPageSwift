//
//  ISScrollViewPageController.swift
//  ISScrollViewPageController
//
//  Created by Daniel Amaral on 11/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

enum ISScrollViewPageType {
    case ISScrollViewPageHorizontally
    case ISScrollViewPageVertically
}

protocol ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(scrollViewPage:ISScrollViewPage,index:Int);
}

class ISScrollViewPage: UIScrollView, UIScrollViewDelegate {
    
    var viewControllers:[UIViewController]?
    var views:[UIView]?
    var scrollViewPageDelegate:ISScrollViewPageDelegate?
    var lastIndex = 0
    var enableBouces:Bool?
    var enablePaging:Bool?
    var scrollViewPageType:ISScrollViewPageType!
    
    //MARK: Life Cycle
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
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
            
            let frame = self.frame.width
            
            if contentOffset.x != 0 {
                index = Int(self.contentOffset.x / frame)
            }else{
                index = 0;
            }
            
        case .ISScrollViewPageVertically:
        
            let frame = self.frame.height
            
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
        
        let countList = self.viewControllers?.count > 0 ? self.viewControllers?.count : self.views?.count
        
        if index >= countList{
            
            UIAlertView(title: "", message: "Index \(index) doesn't has any view controller", delegate: self, cancelButtonTitle: "OK").show()
            
            return
        }
        
        switch(self.scrollViewPageType!){
            
        case .ISScrollViewPageHorizontally:
            
            let frameWidth = Int(self.frame.width)
            let widthOfContentOffset = index * frameWidth
            
            self.setContentOffset(CGPointMake(CGFloat(widthOfContentOffset), 0), animated: animated)
            
        case .ISScrollViewPageVertically:
            
            let frameHeight = Int(self.frame.height)
            let heightOfContentOffset = index * frameHeight
            
            self.setContentOffset(CGPointMake(0, CGFloat(heightOfContentOffset)), animated: animated)
            
        }
        
        if index != lastIndex {
            scrollViewPageDelegate!.scrollViewPageDidChanged(self, index: index)
        }        
        
        lastIndex = index
        
    }
    
    func setControllers(viewControllers:[UIViewController]){
        self.viewControllers! = viewControllers;
    }

    func setCustomViews(views:[UIView]){
        self.views = views
    }
    
    func setEnableBounces(enableBounces:Bool){
        self.bounces = enableBounces
    }

    func setPaging(pagingEnabled:Bool){
        self.enablePaging = pagingEnabled
    }
    
    //MARK: Private Functions
    
    private func initScrollView() {
        super.delegate = self
        self.viewControllers = []
        self.views = []
        self.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageHorizontally
    }
    
    private func setupLayout (scrollViewPageType:ISScrollViewPageType){
        
        var frame:CGRect = self.frame
        var list:[AnyObject] = []
        
        if !viewControllers!.isEmpty {
            list = viewControllers!
        }else {
            list = views!
        }
        
        for i in 0...list.count-1 {

            let object: AnyObject = list[i]
            
            if let objectView = object as? UIView {
                build(list.count,index:i,objectView:objectView,scrollViewPageType: scrollViewPageType)
            }else {
                let objectView = list[i] as! UIViewController
                build(list.count,index:i,objectView:objectView.view,scrollViewPageType: scrollViewPageType)
            }
            
        }
        
        self.pagingEnabled = enablePaging!
        
    }
    
    private func build(numberOfViews:Int,index:Int,objectView:UIView,scrollViewPageType:ISScrollViewPageType) {
        var frame = self.frame
        let view:UIView = UIView()
        
        switch (scrollViewPageType) {
            
        case .ISScrollViewPageHorizontally:
            
            frame.origin.x = CGFloat(self.frame.size.width * CGFloat(index));
            frame.size = self.frame.size
            frame.origin.y = 0
            
            self.contentSize = CGSizeMake(self.frame.size.width * CGFloat(numberOfViews), self.frame.size.height)
            
        case .ISScrollViewPageVertically:
            frame.origin.y = CGFloat(self.frame.size.height * CGFloat(index));
            frame.size = self.frame.size
            frame.origin.x = 0
            
            self.contentSize = CGSizeMake(self.frame.size.width,self.frame.size.height * CGFloat(numberOfViews))
        }
        
        view.frame = frame
        
        view.addSubview(objectView)
        
        self.addSubview(view)
        
    }
    
}
