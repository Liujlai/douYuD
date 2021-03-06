//
//  PageContentView.swift
//  DYTV
//
//  Created by idea on 2017/8/7.
//  Copyright © 2017年 idea. All rights reserved.
//

import UIKit

protocol UIPageContentViewDelegate:class {
    func pageContentView(contentView : PageContentView, progress:CGFloat, sourceIndex : Int, targetIndex: Int)
}



let ContentCellID = "ContentCellID"


class PageContentView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    //MARK: -    定义属性
    var childVcs :[UIViewController]
    weak var parentViewController: UIViewController?
    var startoffsetX :CGFloat = 0
    
    var isForbidScrollDelegate : Bool = false
    weak var delegate : UIPageContentViewDelegate?
    
    //    懒加载属性
    lazy var collectionView: UICollectionView = {[weak self] in
        //        1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        //        行间距
        layout.minimumLineSpacing = 0
        //        item间距
        layout.minimumInteritemSpacing = 0
        //        滚动方向--水平滚动
        layout.scrollDirection = .horizontal
        
        //   2.     创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //        水平方向的指示器
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        //        不希望超出内容的滚动区域
        collectionView.bounces = false
        
        collectionView.dataSource = self
        
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
        }()
    
    //MARK:-    自定义构造函数
    init(frame: CGRect,childVcs :[UIViewController],parentViewController:UIViewController?) {
        self .childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        //        设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//MARK: -设置UI界面
extension PageContentView{
    func setupUI(){
        //       1. 将所有的子控制器添加到父控制器之中
        
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        //        2.添加UICollectionView，用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
//MARK: -  遵守UICollectionViewDataSource
extension PageContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        创建Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        //        给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}
//MARK: - 遵守UICollectionViewDelegate
extension PageContentView:UICollectionViewDelegate{
    //    开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        startoffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        判断是否时点击事件
        if isForbidScrollDelegate{return}
        //  1.      获取需要的数据
        var progress:CGFloat = 0
        var sourceIndex:Int = 0
        var targetIndex:Int = 0
        //  2.       判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startoffsetX { //左滑
            //           1. 计算progress
            progress = currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW)
            //            2. 计算 sourceIndex
            sourceIndex = Int(currentOffsetX/scrollViewW)
            //           3. 计算 targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //          4.  如果完全滑过去
            if currentOffsetX - startoffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else{  //右滑
            
            //           1. 计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            //           2. 计算 targetIndex
            targetIndex = Int(currentOffsetX/scrollViewW)
            //            3. 计算 sourceIndex
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
        }
        // 3.       将progress／sourceIndex／targetIndex传递给 titleView
        //        print("1..\(progress) 2..\(sourceIndex) 3..\(targetIndex)")
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
        
    }
}

//MARK: - 对外暴露的方法
extension PageContentView{
    func setCurrentIndex(currentIndex:Int)  {
        //1. 记录需要禁止执行的代理方法
        isForbidScrollDelegate = true
        //        2. 滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        print(offsetX)
        collectionView.setContentOffset(CGPoint(x: offsetX,y: 0), animated: false)
        
    }
}

