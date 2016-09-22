//
//  ISScrollViewPageController.swift
//  ISScrollViewPageController
//
//  Created by Daniel Amaral on 11/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


@objc public enum ISScrollViewPageType:Int {
    case isScrollViewPageHorizontally = 1
    case isScrollViewPageVertically
}

@objc public protocol ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(_ scrollViewPage:ISScrollViewPage,index:Int);
    @objc optional func scrollViewPageDidScroll(_ scrollView:UIScrollView);
}

open class ISScrollViewPage: UIScrollView, UIScrollViewDelegate {
    
    open var viewControllers:[UIViewController]?
    open var views:[UIView]?
    open var scrollViewPageDelegate:ISScrollViewPageDelegate?
    open var count: Int {
        get {
            let viewsCount = views != nil ? views!.count : 0
            let controllersCount = viewControllers != nil ? viewControllers!.count : 0
            return viewsCount + controllersCount
        }
    }
    var lastIndex = 0
    var enableBouces:Bool?
    var enablePaging:Bool?
    var fillContent:Bool?
    open var scrollViewPageType:ISScrollViewPageType!
    var isLoaded:Bool!

    open func getScrollViewPageTypeFromInt(_ value:Int) -> ISScrollViewPageType {
        switch(value) {
        case 1:
            return .isScrollViewPageHorizontally
        case 2:
            return .isScrollViewPageVertically
        default:
            return .isScrollViewPageHorizontally
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if isLoaded == false{
            setupLayout(scrollViewPageType!)
            isLoaded = true
        }
    }
    
    //MARK: UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollViewPageDelegate = self.scrollViewPageDelegate {
            scrollViewPageDelegate.scrollViewPageDidScroll?(scrollView)
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var index:Int
        
        switch (self.scrollViewPageType!) {
            
        case .isScrollViewPageHorizontally:
            
            let frame = self.frame.width
            
            if contentOffset.x != 0 {
                index = Int(self.contentOffset.x / frame)
            }else{
                index = 0;
            }
            
        case .isScrollViewPageVertically:
            
            let frame = self.frame.height
            
            if contentOffset.y != 0 {
                index = Int(self.contentOffset.y / frame)
            }else{
                index = 0;
            }
            
        }
        
        if index != lastIndex {
            scrollViewPageDelegate?.scrollViewPageDidChanged(self, index: index)
        }
        
        lastIndex = index
        
    }
    
    
    //MARK: Public Functions
    
    open func goToIndex(_ index:Int, animated:Bool){
        
        let countList = self.viewControllers?.count > 0 ? self.viewControllers?.count : self.views?.count
        
        if index >= countList{
            
            UIAlertView(title: "", message: "Index \(index) doesn't has any view controller", delegate: self, cancelButtonTitle: "OK").show()
            
            return
        }
        
        switch(self.scrollViewPageType!){
            
        case .isScrollViewPageHorizontally:
            
            let frameWidth = Int(self.frame.width)
            let widthOfContentOffset = index * frameWidth
            
            self.setContentOffset(CGPoint(x: CGFloat(widthOfContentOffset), y: 0), animated: animated)
            
        case .isScrollViewPageVertically:
            
            let frameHeight = Int(self.frame.height)
            let heightOfContentOffset = index * frameHeight
            
            self.setContentOffset(CGPoint(x: 0, y: CGFloat(heightOfContentOffset)), animated: animated)
            
        }
        
        if index != lastIndex {
            scrollViewPageDelegate?.scrollViewPageDidChanged(self, index: index)
        }
        
        lastIndex = index
        
    }
    
    open func setFillContent(_ fillContent:Bool) {
        self.fillContent = fillContent
        setupLayout(self.scrollViewPageType)
    }
    
    open func setControllers(_ viewControllers:[UIViewController]){
        self.viewControllers! = viewControllers;
        setupLayout(self.scrollViewPageType)
    }
    
    open func addCustomView(_ view:UIView) {
        self.views?.append(view)
        setupLayout(self.scrollViewPageType)
    }
    
    open func setCustomViews(_ views:[UIView]){
        self.views = views
        setupLayout(self.scrollViewPageType)
    }
    
    open func removeCustomViewAtIndex(_ index:Int) {
        if views != nil && !views!.isEmpty{
            self.views!.remove(at: index)
        }
        setupLayout(self.scrollViewPageType)
    }
    
    open func removeCustomView(_ mediaView:UIView) {
        if views != nil && !views!.isEmpty{
            if let index = (views!).index(of: mediaView) {
                self.views!.remove(at: index)
            }
        }
        setupLayout(self.scrollViewPageType)
    }

    open func removeAllViews() {
        views?.removeAll()
        viewControllers?.removeAll()
        setupLayout(self.scrollViewPageType)
    }
    
    open func setEnableBounces(_ enableBounces:Bool){
        self.bounces = enableBounces
    }
    
    open func setPaging(_ pagingEnabled:Bool){
        self.enablePaging = pagingEnabled
    }

    open func setScrollViewPageType(_ value:Int) {
        self.scrollViewPageType = getScrollViewPageTypeFromInt(value);
    }
    
    //MARK: Private Functions
    
    fileprivate func initScrollView() {
        super.delegate = self
        self.viewControllers = []
        self.views = []
        self.scrollViewPageType = ISScrollViewPageType.isScrollViewPageHorizontally
    }
    
    fileprivate func removeSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func setupLayout (_ scrollViewPageType:ISScrollViewPageType){
        
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
        
        self.isPagingEnabled = enablePaging!
        
    }
    
    fileprivate func build(_ numberOfViews:Int,index:Int,objectView:UIView,scrollViewPageType:ISScrollViewPageType) {
        var frame = self.frame
        let view:UIView = UIView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        
        switch (scrollViewPageType) {
            
        case .isScrollViewPageHorizontally:
            
            frame.origin.x = CGFloat(fillContent == true ? self.frame.size.width * CGFloat(index) : objectView.frame.size.width * CGFloat(index));
            frame.size = fillContent == true ? self.frame.size : objectView.frame.size
            frame.origin.y = 0
            
            self.contentSize = CGSize(width: fillContent == true ? self.frame.size.width * CGFloat(numberOfViews) : objectView.frame.size.width * CGFloat(numberOfViews), height: self.frame.size.height)
            
        case .isScrollViewPageVertically:
            frame.origin.y = CGFloat(fillContent == true ? self.frame.size.height * CGFloat(index) : objectView.frame.size.height * CGFloat(index));
            frame.size = fillContent == true ? self.frame.size : objectView.frame.size
            frame.origin.x = 0
            
            self.contentSize = CGSize(width: self.frame.size.width,height: fillContent == true ? self.frame.size.height * CGFloat(numberOfViews) : objectView.frame.size.height * CGFloat(numberOfViews))
        }
        
        view.frame = frame
        
        view.addSubview(objectView)
        
        self.addSubview(view)
        
    }
    
}
