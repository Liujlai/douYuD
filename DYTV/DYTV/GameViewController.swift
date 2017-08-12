//
//  GameViewController.swift
//  DYTV
//
//  Created by idea on 2017/8/12.
//  Copyright © 2017年 idea. All rights reserved.
//

import UIKit
//边缘间距
private let kEdgeMargin :CGFloat = 10
private let kItemW : CGFloat = (kScreenW  - 2 * kEdgeMargin) / 3
private let kItemH : CGFloat = kItemW  * 6 / 5

private let kGameCellID = "kGameCellID"

class GameViewController: UIViewController {
    
    //MARK:懒加载属性
    fileprivate lazy var collectionView: UICollectionView  = { [ unowned  self ]  in
        //        1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
//        最小间距为0
        layout.minimumInteritemSpacing = 0
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: kEdgeMargin, bottom: 0, right: kEdgeMargin)
        
        //      2.  创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        //为了让其显示，注册Cell
        collectionView.register( UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.dataSource = self
        
        return collectionView
        }()
    
    //MARK: 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
    }
    
}

//MARK： 设置UI界面
extension GameViewController{
    fileprivate func setupUI(){
        view.addSubview(collectionView)
    }
}


//MARK:   遵守UICollectionView 的数据源&代理
extension GameViewController :  UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath)
        
        //        设置随机背景颜色
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
    
}