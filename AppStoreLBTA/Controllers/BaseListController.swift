//
//  BaseListController.swift
//  AppStoreLBTA
//
//  Created by VinhHoang on 16/03/2023.
//

import UIKit

class BaseListController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showActivityIndicatory() {
        if Thread.current.isMainThread {
            SpinnerIndicatorController.showIndicator(in: self.view)
        } else {
            DispatchQueue.main.async {
                SpinnerIndicatorController.showIndicator(in: self.view)
            }
        }
    }
    
    func stopIndicator() {
        if Thread.current.isMainThread {
            SpinnerIndicatorController.remove(from: self.view)
        } else {
            DispatchQueue.main.async {
                SpinnerIndicatorController.remove(from: self.view)
            }
        }
    }
}
