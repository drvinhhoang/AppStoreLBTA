//
//  AppHeaderHorizontalController.swift
//  AppStoreLBTA
//
//  Created by VinhHoang on 17/03/2023.
//

import UIKit

class AppHeaderHorizontalController: HorizontalSnappingController {
    let cellId = "cellId"
    var socialApps: [SocialApp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(AppheaderCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialApps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let socialApp = socialApps[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppheaderCell
        cell.companyLabel.text = socialApp.name
        cell.titleLabel.text = socialApp.tagline
        cell.imageView.sd_setImage(with: URL(string: socialApp.imageUrl))
        return cell
    }
}

extension AppHeaderHorizontalController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 24, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 0)
    }
}
