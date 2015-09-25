//
//  TBRPCollectionViewCell.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

enum TBRPCollectionMode {
    case Days
    case Months
}

let TBRPDaysItemHeight: CGFloat = 50.0
let TBRPDaysItemWidth: CGFloat = TBRPScreenWidth / 7.0
let TBRPMonthsItemHeight: CGFloat = 44.0
let TBRPMonthsItemWidth: CGFloat = TBRPScreenWidth / 4.0

let TBRPDaysCollectionHeight: CGFloat = TBRPDaysItemHeight * 5
let TBRPMonthsCollectionHeight: CGFloat = TBRPMonthsItemHeight * 3

private let TBRPCollectionItemID = "TBRPCollectionItem"

class TBRPCollectionViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Public properties
   
    
    // MARK: - Private properties
    private var collectionView: UICollectionView?
    private var mode: TBRPCollectionMode?
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, mode: TBRPCollectionMode) {
        self.init()
        
        self.mode = mode
        let layout = TBRPCollectionViewLayout(mode: mode)
        
        if mode == .Days {
            collectionView = UICollectionView(frame: CGRectMake(0, 0, TBRPScreenWidth, TBRPDaysCollectionHeight), collectionViewLayout: layout)
        } else {
            collectionView = UICollectionView(frame: CGRectMake(0, 0, TBRPScreenWidth, TBRPMonthsCollectionHeight), collectionViewLayout: layout)
        }
        
        if let _ = collectionView {
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView?.registerClass(TBRPCollectionItem.self, forCellWithReuseIdentifier: TBRPCollectionItemID)
            contentView.addSubview(collectionView!)
        }
    }
    
    // MARK: - UICollectionView data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if mode == .Days {
            return 5
        } else {
            return 3
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .Days {
            if section == 4 {
                return 3
            } else {
                return 7
            }
        } else {
            return 4
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TBRPCollectionItemID, forIndexPath: indexPath) as! TBRPCollectionItem
        
        if mode == .Days {
            cell.textLabel!.text = "\(indexPath.row + 1)"
        } else {
            cell.textLabel!.text = "\(indexPath.row + 1)" + "月"
        }
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    // MARK: - UICollectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }

}
