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
}
