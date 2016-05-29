//
//  ISScrollViewPageController.swift
//  ISScrollViewPageController
//
//  Created by Daniel Amaral on 11/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

@objc public enum ISScrollViewPageType:Int {
    case ISScrollViewPageHorizontally = 1
    case ISScrollViewPageVertically
}

@objc public protocol ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(scrollViewPage:ISScrollViewPage,index:Int);
    optional func scrollViewPageDidScroll(scrollView:UIScrollView);
}

public class ISScrollViewPage: UIScrollView, UIScrollViewDelegate {
    
    public var viewControllers:[UIViewController]?
    public var views:[UIView]?
    public var scrollViewPageDelegate:ISScrollViewPageDelegate?
    var lastIndex = 0
    var enableBouces:Bool?
    var enablePaging:Bool?
    var fillContent:Bool?
    public var scrollViewPageType:ISScrollViewPageType!
    var isLoaded:Bool!

    public func getScrollViewPageTypeFromInt(value:Int) -> ISScrollViewPageType {
        switch(value) {
        case 1:
            return .ISScrollViewPageHorizontally
        case 2:
            return .ISScrollViewPageVertically
        default:
            return .ISScrollViewPageHorizontally
        }
    }
    
    //MARK: Life Cycle
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isLoaded = false
        self.initScrollView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isLoaded = false
        self.initScrollView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if isLoaded == false{
            setupLayout(scrollViewPageType!)
            isLoaded = true
        }
    }
    
    //MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let scrollViewPageDelegate = self.scrollViewPageDelegate {
            scrollViewPageDelegate.scrollViewPageDidScroll!(scrollView)
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
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
    
    public func goToIndex(index:Int, animated:Bool){
        
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
    
    public func setFillContent(fillContent:Bool) {
        self.fillContent = fillContent
        setupLayout(self.scrollViewPageType)
    }
    
    public func setControllers(viewControllers:[UIViewController]){
        self.viewControllers! = viewControllers;
        setupLayout(self.scrollViewPageType)
    }
    
    public func addCustomView(view:UIView) {
        self.views?.append(view)
        setupLayout(self.scrollViewPageType)
    }
    
    public func setCustomViews(views:[UIView]){
        self.views = views
        setupLayout(self.scrollViewPageType)
    }
    
    public func removeCustomViewAtIndex(index:Int) {
        if views != nil && !views!.isEmpty{
            self.views!.removeAtIndex(index)
        }
        setupLayout(self.scrollViewPageType)
    }
    
    public func removeCustomView(mediaView:UIView) {
        if views != nil && !views!.isEmpty{
            if let index = (views!).indexOf(mediaView) {
                self.views!.removeAtIndex(index)
            }
        }
        setupLayout(self.scrollViewPageType)
    }
    
    public func setEnableBounces(enableBounces:Bool){
        self.bounces = enableBounces
    }
    
    public func setPaging(pagingEnabled:Bool){
        self.enablePaging = pagingEnabled
    }

    public func setScrollViewPageType(value:Int) {
        self.scrollViewPageType = getScrollViewPageTypeFromInt(value);
    }
    
    //MARK: Private Functions
    
    private func initScrollView() {
        super.delegate = self
        self.viewControllers = []
        self.views = []
        self.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageHorizontally
    }
    
    private func removeSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func setupLayout (scrollViewPageType:ISScrollViewPageType){
        
        removeSubviews()
        
        var list:[AnyObject] = []
        
        if !viewControllers!.isEmpty {
            list = viewControllers!
        }else if !views!.isEmpty{
            list = views!
        }else {
            return
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
        view.userInteractionEnabled = true
        view.clipsToBounds = true
        
        switch (scrollViewPageType) {
            
        case .ISScrollViewPageHorizontally:
            
            frame.origin.x = CGFloat(fillContent == true ? self.frame.size.width * CGFloat(index) : objectView.frame.size.width * CGFloat(index));
            frame.size = fillContent == true ? self.frame.size : objectView.frame.size
            frame.origin.y = 0
            
            self.contentSize = CGSizeMake(fillContent == true ? self.frame.size.width * CGFloat(numberOfViews) : objectView.frame.size.width * CGFloat(numberOfViews), self.frame.size.height)
            
        case .ISScrollViewPageVertically:
            frame.origin.y = CGFloat(fillContent == true ? self.frame.size.height * CGFloat(index) : objectView.frame.size.height * CGFloat(index));
            frame.size = fillContent == true ? self.frame.size : objectView.frame.size
            frame.origin.x = 0
            
            self.contentSize = CGSizeMake(self.frame.size.width,fillContent == true ? self.frame.size.height * CGFloat(numberOfViews) : objectView.frame.size.height * CGFloat(numberOfViews))
        }
        
        view.frame = frame
        
        view.addSubview(objectView)
        
        self.addSubview(view)
        
    }
    
}
