//
//  RecommendCycleView.swift
//  DYTV
//
//  Created by idea on 2017/8/10.
//  Copyright © 2017年 idea. All rights reserved.
//

import UIKit

let kCycleCellID = "kCycleCellID"


class RecommendCycleView: UIView {
    //MARK: - 定义属性
    var cycleTimer : Timer?
    
    var cycleModels : [CycleModel]?{
        didSet{
            //            1.刷新collectionView
            collectionView.reloadData()
            //            2.设置pageControl个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            //           3.默认滚动到中间某个位置
            //            -->刚开始是往前滚时的操作
            let indexPath = NSIndexPath(item: (cycleModels?.count ?? 0) * 10, section: 0)
            collectionView.selectItem(at: indexPath as IndexPath, animated: false, scrollPosition: .left)
            //            4.添加定时器
            removeCycleTimer()
            addCycleTimer()
            
        }
    }
    
    //控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    //    系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //        注册Cell
        
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
        //        设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.isPagingEnabled = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //        左右进行滚动
        layout.scrollDirection = .horizontal
        
        collectionView.isPagingEnabled = true
    }
    
}


//MARK: - 提供一个快速创建View的类方法

extension RecommendCycleView{
    class func recommendCycleView() -> RecommendCycleView{
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
        
    }
}

//MARK: - 遵守UICollectionView的数据源协议
extension RecommendCycleView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //无限轮播 *10000
        return (cycleModels?.count ?? 0) * 10000
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        //无限轮播 % (cycleModels?.count)!
        cell.cycleModel = cycleModels![indexPath.item % (cycleModels?.count)!]
        
        //        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red :UIColor.blue
        return cell
    }
    
}


//MARK: -遵守UICollectonView的代理协议

extension RecommendCycleView : UICollectionViewDelegate{
    //    监听滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        1.获取滚动的偏移量 ----->+ scrollView.bounds.width * 0.5 是滑动到一半的时候显示下一张
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        //        2.计算pageControl的currentIndex
        //无限轮播 % (cycleModels?.count ?? 1) --->对到最后page View不动了的修改
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    //        监听用户的拖拽
    //    开始拖拽移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    //    结束拖拽添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
    
    
}


//MARK: 对定时器的操作方法

extension RecommendCycleView{
    func addCycleTimer(){
        cycleTimer = Timer(timeInterval: 3.0, target: self , selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode:RunLoopMode.commonModes)
    }
    
    func removeCycleTimer()  {
        cycleTimer?.invalidate()// 从运行循环中移除
        cycleTimer = nil
    }
    //滚动到下一个
    @objc func scrollToNext(){
        //        1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        //        2.滚动到该位置
        collectionView.setContentOffset(CGPoint(x: offsetX,y : 0), animated: true)
        
    }
}
