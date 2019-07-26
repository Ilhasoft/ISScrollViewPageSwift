//
//  ISScrollViewPageController.swift
//  ISScrollViewPageController
//
//  Created by Daniel Amaral on 11/02/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

@objc public enum ISScrollViewPageType:Int {
    case horizontally = 1
    case vertically
}

@objc public protocol ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(_ scrollViewPage:ISScrollViewPage, index: Int);
    @objc optional func scrollViewPageDidScroll(_ scrollView: UIScrollView);
}

open class ISScrollViewPage: UIScrollView, UIScrollViewDelegate {
    
    open var viewControllers: [UIViewController]?
    open var views = [UIView]()
    open weak var scrollViewPageDelegate: ISScrollViewPageDelegate?
    open var count: Int {
        let viewsCount = views.count
        let controllersCount = viewControllers != nil ? viewControllers!.count : 0
        return viewsCount + controllersCount
    }
    var lastIndex = 0
    var enableBouces: Bool?
    var enablePaging: Bool?
    var fillContent: Bool?
    open var scrollViewPageType: ISScrollViewPageType!
    var isLoaded: Bool!
    var sizeOfViews: CGFloat = 0
        
    open func getScrollViewPageTypeFromInt(_ value: Int) -> ISScrollViewPageType {
        switch(value) {
        case 1:
            return .horizontally
        case 2:
            return .vertically
        default:
            return .horizontally
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
        scrollViewPageDelegate?.scrollViewPageDidScroll?(scrollView)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var index:Int
        
        switch (scrollViewPageType!) {
            
        case .horizontally:
            
            let frame = self.frame.width
            
            if contentOffset.x != 0 {
                index = Int(contentOffset.x / frame)
            } else{
                index = 0;
            }
            
        case .vertically:
            
            let frame = self.frame.height
            
            if contentOffset.y != 0 {
                index = Int(contentOffset.y / frame)
            } else{
                index = 0;
            }
            
        }
        
        if index != lastIndex {
            scrollViewPageDelegate?.scrollViewPageDidChanged(self, index: index)
        }
        
        lastIndex = index
        
    }
    
    
    //MARK: Public Functions
    
    open func goToIndex(_ index: Int, animated: Bool){
        
        let countList = (viewControllers?.count)! > 0 ? viewControllers?.count : views.count
        
        if index >= countList! {
            
            UIAlertView(title: "", message: "Index \(index) doesn't has any view controller", delegate: self, cancelButtonTitle: "OK").show()
            
            return
        }
        
        switch(self.scrollViewPageType!){
            
        case .horizontally:
            
            let frameWidth = Int(frame.width)
            let widthOfContentOffset = index * frameWidth
            
            self.setContentOffset(CGPoint(x: CGFloat(widthOfContentOffset), y: 0), animated: animated)
            
        case .vertically:
            
            let frameHeight = Int(self.frame.height)
            let heightOfContentOffset = index * frameHeight
            
            self.setContentOffset(CGPoint(x: 0, y: CGFloat(heightOfContentOffset)), animated: animated)
            
        }
        
        if index != lastIndex {
            scrollViewPageDelegate?.scrollViewPageDidChanged(self, index: index)
        }
        
        lastIndex = index
        
    }
    
    open func setFillContent(_ fillContent: Bool) {
        self.fillContent = fillContent
        setupLayout(scrollViewPageType)
    }
    
    open func setControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers! = viewControllers;
        setupLayout(scrollViewPageType)
    }
    
    open func addCustomView(_ view: UIView) {
        views.append(view)
        setupLayout(scrollViewPageType)
    }
    
    open func setCustomViews(_ views: [UIView]) {
        self.views = views
        setupLayout(scrollViewPageType)
    }
    
    open func removeCustomViewAtIndex(_ index: Int) {
        if !views.isEmpty {
            views.remove(at: index)
        }
        setupLayout(scrollViewPageType)
    }
    
    open func removeCustomView(_ mediaView: UIView) {
        if !views.isEmpty{
            if let index = (views).firstIndex(of: mediaView) {
                views.remove(at: index)
            }
        }
        setupLayout(scrollViewPageType)
    }
    
    open func removeAllViews() {
        views.removeAll()
        viewControllers?.removeAll()
        setupLayout(scrollViewPageType)
    }
    
    open func setEnableBounces(_ enableBounces: Bool) {
        bounces = enableBounces
    }
    
    open func setPaging(_ pagingEnabled: Bool) {
        enablePaging = pagingEnabled
    }
    
    open func setScrollViewPageType(_ value: Int) {
        scrollViewPageType = getScrollViewPageTypeFromInt(value);
    }
    
    //MARK: Private Functions
    
    fileprivate func initScrollView() {
        super.delegate = self
        viewControllers = []
        views = []
        scrollViewPageType = ISScrollViewPageType.horizontally
    }
    
    fileprivate func removeSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func setupLayout (_ scrollViewPageType: ISScrollViewPageType) {
        
        sizeOfViews = 0
        removeSubviews()
        
        var list: [AnyObject] = []
        
        if !viewControllers!.isEmpty {
            list = viewControllers!
        } else if !views.isEmpty{
            list = views
        } else {
            return
        }
        
        for i in 0...list.count-1 {
            
            let object: AnyObject = list[i]
            
            if let objectView = object as? UIView {
                build(list.count,index:i,objectView:objectView,scrollViewPageType: scrollViewPageType)
            } else {
                let objectView = list[i] as! UIViewController
                build(list.count, index: i, objectView:objectView.view, scrollViewPageType: scrollViewPageType)
            }
            
        }
        
        self.isPagingEnabled = enablePaging!
    }
    
    fileprivate func build(_ numberOfViews: Int, index: Int, objectView: UIView, scrollViewPageType: ISScrollViewPageType) {
        var frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        let view:UIView = UIView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        
        switch (scrollViewPageType) {
        case .horizontally:
            sizeOfViews = sizeOfViews + objectView.frame.size.width
            
            frame.origin.x = CGFloat(fillContent == true ? self.frame.size.width * CGFloat(index) : index == 0 ? 0 : sizeOfViews - objectView.frame.size.width);
            frame.size = fillContent == true ? self.frame.size : objectView.frame.size
            frame.origin.y = 0
            
            self.contentSize = CGSize(width: fillContent == true ? self.frame.size.width * CGFloat(numberOfViews) : sizeOfViews, height: self.frame.size.height)
            
        case .vertically:
            sizeOfViews = sizeOfViews + objectView.frame.size.height
            
            frame.origin.y = CGFloat(fillContent == true ? self.frame.size.height * CGFloat(index) : index == 0 ? 0 : sizeOfViews - objectView.frame.size.height);
            frame.size = fillContent == true ? self.frame.size : objectView.frame.size
            frame.origin.x = 0
            
            self.contentSize = CGSize(width: self.frame.size.width,height: fillContent == true ? self.frame.size.height * CGFloat(numberOfViews) : sizeOfViews)
        }
        
        view.frame = frame
        view.addSubview(objectView)
        addSubview(view)
    }
}
