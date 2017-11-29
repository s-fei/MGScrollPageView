//
//  TabListViewController.swift
//  MogoPartner
//
//  Created by song on 2016/12/31.
//  Copyright © 2016年 mogoroom. All rights reserved.
//

import UIKit
import MGScrollPageView

@objc class TabListViewController: MGTabViewController {
    @IBOutlet weak var bottomLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titles = ["新闻大事","军事大事","上海新闻"]
        let textVC = TextViewController(nibName: "TextViewController", bundle: nil)
        subViewControllers = [PageCollectionViewController(),PageTableViewController(),textVC];
        headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        headView?.backgroundColor = UIColor.green
        keepTab = true
        autoHiddenNavBar = false
        autoContentSize = true
        style.isScrollTitle = false
        style.titleMargin = 0
        reloadView()
//        setSelectedIndex(index: 2, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.bringSubview(toFront: bottomLabel)
    }
    
    override func scrollTabController(scrollPageController: UIViewController!, childViewControllDidAppear childViewController: UIViewController!, forIndex index: Int) {
        print("显示\(currentSubViewController)  index:\(currentIndex)")
       
    }

}
