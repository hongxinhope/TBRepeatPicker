//
//  TBRPCollectionViewCell.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

enum TBRPCollectionMode {
    case days
    case months
}

let TBRPDaysItemWidth: CGFloat = TBRPScreenWidth / 7.0
let TBRPDaysItemHeight = CGFloat((Int)(TBRPDaysItemWidth * 0.9 + 0.5))
let TBRPMonthsItemWidth: CGFloat = TBRPScreenWidth / 4.0
let TBRPMonthsItemHeight: CGFloat = 44.0

let TBRPDaysCollectionHeight: CGFloat = TBRPDaysItemHeight * 5
let TBRPMonthsCollectionHeight: CGFloat = TBRPMonthsItemHeight * 3

private let TBRPCollectionItemID = "TBRPCollectionItem"

protocol TBRPCollectionViewCellDelegate {
    func selectedMonthdaysDidChanged(_ days: [Int])
    func selectedMonthsDidChanged(_ months: [Int])
}

class TBRPCollectionViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Public properties
    var language: TBRPLanguage = .english
    var selectedMonthdays = [Int]()
    var selectedMonths = [Int]()
    var delegate: TBRPCollectionViewCellDelegate?
    
    // MARK: - Private properties
    fileprivate var collectionView: UICollectionView?
    fileprivate var mode: TBRPCollectionMode?
    
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
        if mode == .months {
            addSectionTopSeparator()
            addSectionBottomSeparator()
        }
        
        self.language = language
        let layout = TBRPCollectionViewLayout(mode: mode)
        
        if mode == .days {
            collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: TBRPScreenWidth, height: TBRPDaysCollectionHeight), collectionViewLayout: layout)
        } else {
            collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: TBRPScreenWidth, height: TBRPMonthsCollectionHeight), collectionViewLayout: layout)
        }
        
        if let _ = collectionView {
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView?.register(TBRPCollectionItem.self, forCellWithReuseIdentifier: TBRPCollectionItemID)
            collectionView?.backgroundColor = UIColor.clear
            contentView.addSubview(collectionView!)
        }
        backgroundColor = UIColor.clear
    }
    
    // MARK: - Separator line
    func removeAllSeparators() {
        for sublayer in layer.sublayers! {
            if sublayer.name == TBRPTopSeparatorIdentifier || sublayer.name == TBRPBottomSeparatorIdentifier {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func addBottomSeparatorFromLeftX(_ leftX: CGFloat) {
        let bottomSeparator = CALayer()
        bottomSeparator.name = TBRPBottomSeparatorIdentifier
        
        bottomSeparator.frame = CGRect(x: leftX, y: TBRPMonthsCollectionHeight - TBRPSeparatorLineWidth, width: TBRPScreenWidth - leftX, height: TBRPSeparatorLineWidth)
        bottomSeparator.backgroundColor = TBRPHelper.separatorColor()
        
        layer.addSublayer(bottomSeparator)
    }
    
    func addTopSeparatorFromLeftX(_ leftX: CGFloat) {
        let topSeparator = CALayer()
        topSeparator.name = TBRPTopSeparatorIdentifier
        
        topSeparator.frame = CGRect(x: leftX, y: 0,width: TBRPScreenWidth - leftX, height: TBRPSeparatorLineWidth)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .days {
            return 31
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TBRPCollectionItemID, for: indexPath) as! TBRPCollectionItem
        cell.tintColor = tintColor
        
        if mode == .days {
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
    
    func configureSeparatorLine(_ cell: TBRPCollectionItem,indexPath: IndexPath) {
        if mode == .days {
            cell.showTopLine = false
            cell.showLeftLine = false
            
            if (indexPath.row + 1) % 7 == 0 {
                cell.showRightLine = false
            }
            
        } else if mode == .months {
            cell.showBottomLine = false
            if indexPath.row + 1 < 5 {
                cell.showTopLine = false
            }
            
            cell.showLeftLine = false
            if (indexPath.row + 1) % 4 == 0 {
                cell.showRightLine = false
            }
        }
    }
    
    // MARK: - UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TBRPCollectionItem
        
        if mode == .days {
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
            cell.backgroundColor = UIColor.white
            
            if let _ = delegate {
                delegate?.selectedMonthdaysDidChanged(selectedMonthdays)
            }
        } else if mode == .months {
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
