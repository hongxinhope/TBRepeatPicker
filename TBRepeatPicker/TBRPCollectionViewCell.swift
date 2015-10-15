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

let TBRPDaysItemWidth: CGFloat = TBRPScreenWidth / 7.0
let TBRPDaysItemHeight = CGFloat((Int)(TBRPDaysItemWidth * 0.9 + 0.5))
let TBRPMonthsItemWidth: CGFloat = TBRPScreenWidth / 4.0
let TBRPMonthsItemHeight: CGFloat = 44.0

let TBRPDaysCollectionHeight: CGFloat = TBRPDaysItemHeight * 5
let TBRPMonthsCollectionHeight: CGFloat = TBRPMonthsItemHeight * 3

private let TBRPCollectionItemID = "TBRPCollectionItem"

protocol TBRPCollectionViewCellDelegate {
    func selectedMonthdaysDidChanged(days: [Int])
    func selectedMonthsDidChanged(months: [Int])
}

class TBRPCollectionViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Public properties
    var language: TBRPLanguage = .English
    var selectedMonthdays = [Int]()
    var selectedMonths = [Int]()
    var delegate: TBRPCollectionViewCellDelegate?
    
    // MARK: - Private properties
    private var collectionView: UICollectionView?
    private var mode: TBRPCollectionMode?
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeAllSeparators()
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, mode: TBRPCollectionMode, language: TBRPLanguage) {
        self.init()
        
        separatorInset = UIEdgeInsetsMake(0, TBRPScreenWidth, 0, 0)
        
        self.mode = mode
        self.language = language
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
            collectionView?.backgroundColor = UIColor.clearColor()
            contentView.addSubview(collectionView!)
        }
        backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Separator line
    func removeAllSeparators() {
        for sublayer in layer.sublayers! {
            if sublayer.name == TBRPTopSeparatorIdentifier || sublayer.name == TBRPBottomSeparatorIdentifier {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func addBottomSeparatorFromLeftX(leftX: CGFloat) {
        let bottomSeparator = CALayer()
        bottomSeparator.name = TBRPBottomSeparatorIdentifier
        
        bottomSeparator.frame = CGRectMake(leftX, TBRPMonthsCollectionHeight - TBRPSeparatorLineWidth, TBRPScreenWidth - leftX, TBRPSeparatorLineWidth)
        bottomSeparator.backgroundColor = TBRPHelper.separatorColor()
        
        layer.addSublayer(bottomSeparator)
    }
    
    func addTopSeparatorFromLeftX(leftX: CGFloat) {
        let topSeparator = CALayer()
        topSeparator.name = TBRPTopSeparatorIdentifier
        
        topSeparator.frame = CGRectMake(leftX, 0,TBRPScreenWidth - leftX, TBRPSeparatorLineWidth)
        topSeparator.backgroundColor = TBRPHelper.separatorColor()
        
        layer.addSublayer(topSeparator)
    }
    
    func addSectionTopSeparator() {
        addTopSeparatorFromLeftX(0)
    }
    
    func addSectionBottomSeparator() {
        addBottomSeparatorFromLeftX(0)
    }
    
    // MARK: - UICollectionView data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .Days {
            return 31
        } else {
            return 12
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TBRPCollectionItemID, forIndexPath: indexPath) as! TBRPCollectionItem
        cell.tintColor = tintColor
        
        if mode == .Days {
            let day = indexPath.row + 1
            
            cell.textLabel!.text = "\(day)"
            cell.setItemSelected(selectedMonthdays.contains(day))
        } else {
            let month = indexPath.row + 1
            
            cell.textLabel!.text = TBRPHelper.yearMonths(language)[indexPath.row]
            cell.setItemSelected(selectedMonths.contains(month))
        }
        
        configureSeparatorLine(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureSeparatorLine(cell: TBRPCollectionItem,indexPath: NSIndexPath) {
        if mode == .Days {
            if indexPath.row + 1 > 7 {
                cell.showTopLine = false
            }
            cell.showLeftLine = false
            
            if (indexPath.row + 1) % 7 == 0 {
                cell.showRightLine = false
            }
            
        } else if mode == .Months {
            if indexPath.row + 1 < 9 {
                cell.showBottomLine = false
            }
            
            cell.showLeftLine = false
            if (indexPath.row + 1) % 4 == 0 {
                cell.showRightLine = false
            }
        }
    }
    
    // MARK: - UICollectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TBRPCollectionItem
        
        if mode == .Days {
            let day = indexPath.row + 1
            if selectedMonthdays.count == 1 && selectedMonthdays.contains(day) == true {
                return
            }
            
            cell.setItemSelected(!selectedMonthdays.contains(day))
            
            if selectedMonthdays.contains(day) == true {
                selectedMonthdays.removeObject(day)
            } else {
                selectedMonthdays.append(day)
            }
            cell.backgroundColor = UIColor.whiteColor()
            
            if let _ = delegate {
                delegate?.selectedMonthdaysDidChanged(selectedMonthdays)
            }
        } else if mode == .Months {
            let month = indexPath.row + 1
            if selectedMonths.count == 1 && selectedMonths.contains(month) == true {
                return
            }
            
            cell.setItemSelected(!selectedMonths.contains(month))
            
            if selectedMonths.contains(month) == true {
                selectedMonths.removeObject(month)
            } else {
                selectedMonths.append(month)
            }
            
            if let _ = delegate {
                delegate?.selectedMonthsDidChanged(selectedMonths)
            }
        }
    }

}
