//
//  PageViewController.swift
//  MogoRenter
//
//  Created by song on 2016/12/20.
//  Copyright © 2016年 MogoRoom. All rights reserved.
//

import UIKit
import MGScrollPageView

// MARK: PageTableViewDelegate
public protocol PageViewDelegate: class {
    func scrollViewIsScrolling(scrollView: UIScrollView)
}


open class PageViewController: UIViewController, UIScrollViewDelegate {
    // 代理
    public var scrollView:UIScrollView?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
//        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    public weak var delegate: PageViewDelegate?
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.scrollView == nil)
        {
           self.scrollView = scrollView
        }
        delegate?.scrollViewIsScrolling(scrollView: scrollView)
    }
}

extension PageViewController: ZJScrollPageViewChildVcDelegate {
    
    
}

