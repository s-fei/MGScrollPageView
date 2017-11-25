//
//  MGTabViewController.swift
//  MogoRenter
//
//  Created by song on 2016/12/20.
//  Copyright © 2016年 MogoRoom. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let KScreenWidth = UIScreen.main.bounds.width
fileprivate let KScreenHeight = UIScreen.main.bounds.height

// MARK:外部使用方法
extension MGTabViewController{
    public func reloadView(){
        tableView.delegate = self
        tableView.dataSource = self
        if headView == nil || headView?.frame.size.height == 0  {
            headView = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width , height:  0.01))
            if keepTab {
                self.tableViewScrollEnabled = false
                tableView.isScrollEnabled = self.tableViewScrollEnabled
            }
        }
        tableView.tableHeaderView = headView
        tableView.reloadData()
        segmentView.reloadTitles(withNewTitles: titles)
          contentView.reload()
    }
    
    /*! 设置选中哪个 */
    public func setSelectedIndex(index: Int, animated: Bool){
        segmentView.setSelectedIndex(index, animated: animated)
    }
    
    /**
     *  页面将要出现
     *
     *  @param scrollPageController
     *  @param childViewController
     *  @param index
     */
    open func scrollTabController(scrollPageController: UIViewController!, childViewControllWillAppear childViewController: UIViewController!, forIndex index: Int) {
        
    }
    /**
     *  页面已经出现
     *
     *  @param scrollPageController
     *  @param childViewController
     *  @param index
     */
    open func  scrollTabController(scrollPageController: UIViewController!, childViewControllDidAppear childViewController: UIViewController!, forIndex index: Int) {
        
    }
    
    open func scrollTabController(scrollPageController: UIViewController!, childViewControllWillDisappear childViewController: UIViewController!, forIndex index: Int) {
        
    }
    
    open func scrollTabController(scrollPageController: UIViewController!, childViewControllDidDisappear childViewController: UIViewController!, forIndex index: Int) {
        
    }
    
    open func setUpTabTitleView(titleView: ZJTitleView!, forIndex index: Int){
        
    }
}

open class MGTabViewController: UIViewController {
    // MARK:外部使用方法
    /*! Tab的头 不设置就是没有头啦 */
    public var headView:UIView?
    /*! Tab切换的title */
    public var titles:[String] = []
    /*! 必须和titles一一对应 */
    public var subViewControllers:[PageViewController] = []
    /*! 当前显示的ViewController */
    public var currentSubViewController:PageViewController?
    /*! 当前显示的Index */
    public var currentIndex:Int?
    /*! 设置Tab的样式 */
    public var style = ZJSegmentStyle()
    /*! 是否保持Tab在屏幕内容 */
    public var keepTab = true
    /*! 是否保持Tab在屏幕内容 */
    public var autoHiddenNavBar = false
    /*! 是否自动隐藏segmentView 当只有一个Tab的时候*/
    public var autoHiddensegmentView = false{
        didSet{
            if autoHiddenNavBar && autoContentSize {
                assertionFailure("暂时不支持autoHiddenNavBar和autoContentSize一起用")
            }
        }
    }
    /*! 是否需要子ViewController悬浮一些东西 比如：底部Button  但是不要和autoHiddenNavBar一起用*/
    public var autoContentSize = false{
        didSet{
            if autoHiddenNavBar && autoContentSize {
                assertionFailure("暂时不支持autoHiddenNavBar和autoContentSize一起用")
            }
        }
    }
    
    public var isSubRefresh = false
    
    public var bottomMargin = 0 {
        didSet{
            if self.view.subviews.contains(self.tableView) {
                self.tableView.snp.updateConstraints { (make) in
                    make.bottom.equalTo(self.view).offset(-bottomMargin)
                }
            }
        }
    }
    
    
    // 懒加载tableView, 注意如果是从storyBoard中连线过来的,那么注意设置contentView的高度有点不一样
    // 或者在滚动的时候需要渐变navigationBar的时候,需要注意相关的tableView的frame设置和contentInset的设置
    public lazy var tableView: MGCustomGestureTableView = {
        let table = MGCustomGestureTableView(frame:self.view.bounds, style: .grouped)
        table.backgroundColor = UIColor(red: 248.0 / 255, green: 248.0 / 255, blue: 248.0 / 255, alpha: 1)
        table.tableFooterView = UIView();
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false;
        return table
    }()
    
    public lazy var segmentView:ZJScrollSegmentView = {
        let segment = ZJScrollSegmentView(frame: CGRect(x: 0.0, y: 0.0, width: KScreenWidth, height: self.style.segmentHeight), segmentStyle: self.style, delegate: self, titles: self.titles, titleDidClick: {
            [weak self](titleView, index) in
            guard let strongSelf = self else { return }
            if index != strongSelf.contentView.contentIndex
            {
                strongSelf.contentView.contentIndex = index
            }
        })
        segment?.backgroundColor = UIColor.white
        return segment!
    }()
    
    
    // 懒加载contentView
    public lazy var contentView: ZJContentView! = {[unowned self] in
        // 注意, 如果tableview是在storyboard中来的, 设置contentView的高度和这里不一样
        let content = ZJContentView(frame: self.contentViewFrame, segmentView: self.segmentView, parentViewController: self, delegate: self)
        return content
        }()
    
    public lazy var contentViewFrame: CGRect! = {[unowned self] in
        // 注意, 如果tableview是在storyboard中来的, 设置contentView的高度和这里不一样
        let hotHeight = self.keepTab ? self.style.segmentHeight: 0
        var frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - hotHeight - 64)
        return frame
        }()
    
    public var tableViewScrollEnabled = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = .bottom
        automaticallyAdjustsScrollViewInsets = false
        
        style.isAutoAdjustTitlesWidth = true
        // 滚动条
        style.isShowLine = true
        // 颜色渐变
        style.isGradualChangeTitleColor = true
        // 滚动条颜色
        style.scrollLineColor = UIColor(red: 246.0 / 255, green: 80.0 / 255, blue: 0.0 / 255, alpha: 1)
        // title正常状态颜色 使用RGB空间值
        style.normalTitleColor = UIColor(red: 51.0 / 255, green: 51.0 / 255, blue: 51.0 / 255, alpha: 1)
        // title选中状态颜色 使用RGB空间值
        style.selectedTitleColor = UIColor(red: 246.0 / 255, green: 80.0 / 255, blue: 0.0 / 255, alpha: 1)
        style.coverHeight = 5
        style.segmentHeight = 40
        style.isShowLineBgView = true
        style.lineBgColor = UIColor(red: 191.0 / 255, green: 191.0 / 255, blue: 191.0 / 255, alpha: 1).withAlphaComponent(0.7)
        style.isAdjustCoverOrLineWidth = true
        style.isScrollTitle = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-bottomMargin)
        }
    }
    
    func popPre()
    {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.navigationController?.isNavigationBarHidden == true {
            let hotHeight = self.keepTab ? self.style.segmentHeight: 0
            contentViewFrame = CGRect(x: 0, y: 0, width: KScreenWidth, height: tableView.bounds.height - hotHeight)
            tableView.reloadData()
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_backArrow"), style: .plain, target: nil, action: nil)
        //        leftBarButtonItem.setActionBlock({[weak self]
        //            () in
        //            guard let strongSelf = self else { return }
        //            let _ = strongSelf.navigationController?.popViewController(animated: true)
        //        })
        //        leftBarButtonItem.tintColor = kColors_MogoRed;
    }
    
    func hotHeight() -> CGFloat{
        var hotHeight = keepTab ? 0: style.segmentHeight
        if let headView = headView {
            if headView.bounds.height >= 1 {
                hotHeight = hotHeight + headView.bounds.height
            }
        }
        return hotHeight - 0.0000001
    }
    
    override open func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    func changeNavBar(scrollView:UIScrollView,isAuto:Bool = true)
    {
        if isAuto == true {
            if autoHiddenNavBar && self.navigationController != nil{
                let pan = scrollView.panGestureRecognizer
                let velocity = pan.velocity(in: scrollView).y
                if velocity < -5 && self.navigationController?.isNavigationBarHidden == false {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    let hotHeight = self.keepTab ? self.style.segmentHeight: 0
                    contentViewFrame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - hotHeight)
                    tableView.reloadData()
                } else if velocity > 5 && self.navigationController?.isNavigationBarHidden == true {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    let hotHeight = self.keepTab ? self.style.segmentHeight: 0
                    let frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - hotHeight)
                    contentViewFrame = frame
                    tableView.reloadData()
                }
            }
        }
        else {
            if autoHiddenNavBar && self.navigationController != nil  && self.navigationController?.isNavigationBarHidden == true{
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                let hotHeight = self.keepTab ? self.style.segmentHeight: 0
                let frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - hotHeight)
                contentViewFrame = frame
                tableView.reloadData()
            }
        }
    }
}

extension MGTabViewController: ZJScrollPageViewDelegate
{
    
    public func setUp(_ titleView: ZJTitleView!, for index: Int) {
        
    }
    
    public func frameOfChildController(forContainer containerView: UIView!) -> CGRect {
        return containerView.bounds
    }
    
    public func numberOfChildViewControllers() -> Int {
        return titles.count
    }
    
    public func childViewController(_ reuseViewController: UIViewController!, for index: Int) -> UIViewController! {
        if reuseViewController == nil && subViewControllers.count > index{
            let viewController = subViewControllers[index]
            viewController.delegate = self
            return viewController
        }
        return reuseViewController
    }
    
    //
    //    func scrollPageController(scrollPageController: UIViewController!, contentScrollView scrollView: ZJCollectionView!, shouldBeginPanGesture panGesture: UIPanGestureRecognizer!) -> Bool {
    //        return true
    //    }
    //
    public func scrollPageController(_ scrollPageController: UIViewController!, childViewControllWillAppear childViewController: UIViewController!, for index: Int) {
        scrollTabController(scrollPageController: scrollPageController, childViewControllWillAppear: childViewController, forIndex: index)
    }
    
    public func  scrollPageController(_ scrollPageController: UIViewController!, childViewControllDidAppear childViewController: UIViewController!, for index: Int) {
        currentIndex = index
        if let pageViewController = childViewController as? PageViewController {
            currentSubViewController = pageViewController
        }
        else
        {
            currentSubViewController = nil
        }
        scrollTabController(scrollPageController:scrollPageController, childViewControllDidAppear: childViewController, forIndex: index)
    }
    
    public func scrollPageController(_ scrollPageController: UIViewController!, childViewControllWillDisappear childViewController: UIViewController!, for index: Int) {
        scrollTabController(scrollPageController:scrollPageController, childViewControllWillDisappear: childViewController, forIndex: index)
    }
    
    public func scrollPageController(_ scrollPageController: UIViewController!, childViewControllDidDisappear childViewController: UIViewController!, for index: Int) {
        scrollTabController(scrollPageController:scrollPageController, childViewControllDidDisappear: childViewController, forIndex: index)
    }
    
    func setUpTitleView(titleView: ZJTitleView!, forIndex index: Int) {
        setUpTabTitleView(titleView: titleView, forIndex: index)
    }
}

// MARK:- UITableViewDataSource UITableViewDelegate
extension MGTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contentViewFrame.height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return style.segmentHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.contentView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        cell.contentView.addSubview(contentView)
        cell.selectionStyle = .none
        if autoContentSize {
            var segmentViewHeight = segmentView.frame.height
            if autoHiddensegmentView && subViewControllers.count <= 1 {
                segmentViewHeight = CGFloat.leastNormalMagnitude
            }
            contentView.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height:tableView.frame.height -  (headView!.frame.height +  segmentViewHeight - tableView.contentOffset.y))
        }
        else
        {
            contentView.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalTo(cell.contentView)
            }
        }
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if autoHiddensegmentView && subViewControllers.count <= 1 {
            return nil
        }
        return segmentView
    }
}

extension MGTabViewController:PageViewDelegate
{
    public func scrollViewIsScrolling(scrollView: UIScrollView) {
        if isSubRefresh && self.tableViewScrollEnabled && tableView.contentOffset.y <= 0 {
            tableView.isScrollEnabled =  scrollView.contentOffset.y >= 0
            if !tableView.isScrollEnabled {
                return
            }
        }
        tableView.isScrollEnabled = self.tableViewScrollEnabled
        
        let height = hotHeight()
        if tableView.contentOffset.y < height
        {
            scrollView.contentOffset = CGPoint.zero
            scrollView.showsVerticalScrollIndicator = false
        }
        else
        {
            self.tableView.contentOffset.y = height
            scrollView.showsVerticalScrollIndicator = true
            changeNavBar(scrollView: scrollView)
        }
    }
}

extension MGTabViewController:UIScrollViewDelegate
{
    open func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        if isSubRefresh && scrollView.contentOffset.y <= 0 {
            tableView.contentOffset = CGPoint.zero
        }
        
        var height = hotHeight()
        if let pageViewController = currentSubViewController, let childScrollView = pageViewController.scrollView{
            if childScrollView.contentOffset.y > 0 {
                tableView.contentOffset.y = height
            }
            if scrollView.contentOffset.y  < height {
                childScrollView.contentOffset = CGPoint.zero
            }
            else
            {
                tableView.contentOffset.y = height
            }
            if autoContentSize {
                if scrollView.contentOffset.y  < height {
                    contentView.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height:tableView.frame.height -  (headView!.frame.height +  segmentView.frame.height - tableView.contentOffset.y))
                }
                else
                {
                    contentView.frame = contentViewFrame
                }
            }
            if childScrollView.contentSize.height <= childScrollView.bounds.height {
                if tableView.contentOffset.y >= height
                {
                    self.tableView.contentOffset.y = height
                    changeNavBar(scrollView: scrollView)
                }
                else
                {
                    changeNavBar(scrollView: scrollView, isAuto: false)
                }
            }
        }
        else
        {
            if !keepTab {
                height = height - self.style.segmentHeight
            }
            if scrollView.contentOffset.y >= height {
                scrollView.setContentOffset(CGPoint(x:0,y:height), animated: false)
                changeNavBar(scrollView: scrollView)
            }
            else
            {
                changeNavBar(scrollView: scrollView, isAuto: false)
            }
        }
    }
    
}


public class MGCustomGestureTableView: UITableView {
    
    /// 返回true  ---- 能同时识别多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let isGesture = (gestureRecognizer is UIPanGestureRecognizer) && (otherGestureRecognizer is UIPanGestureRecognizer)
        if isGesture {
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            let point = panGesture.translation(in: self.superview)
            if abs(point.y) == 0 {
                return abs(point.x) <= abs(point.y)
            }
            else
            {
                return abs(point.x)/abs(point.y) < 0.5
            }
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!)->Bool{
        if touch.view is UIButton {
            return false
        }
        return true
    }
}

