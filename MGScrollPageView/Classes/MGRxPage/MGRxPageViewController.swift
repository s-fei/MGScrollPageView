//
//  PageViewController.swift
//  MogoRenter
//
//  Created by song on 2016/12/20.
//  Copyright © 2016年 MogoRoom. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

open class MGRXPageViewController: PageViewController {
    
    let pageDisposeBag = DisposeBag()
    // 代理
    open override var scrollView:UIScrollView? {
        didSet{
            guard let `scrollView` = scrollView else { return }
            scrollView.rx
                .didScroll
                .asObservable()
                .observeOn(MainScheduler.asyncInstance)
                .bind(to: rx.didScroll)
                .disposed(by: pageDisposeBag)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension Reactive where Base : MGRXPageViewController {
    
    var didScroll: Binder<Void> {
        return Binder(self.base, binding: { (vc, _) in
            if let scrollView = vc.scrollView {
                vc.delegate?.scrollViewIsScrolling(scrollView: scrollView)
            }
        })
    }
}

