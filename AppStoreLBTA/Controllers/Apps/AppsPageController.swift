//
//  AppsController.swift
//  AppStoreLBTA
//
//  Created by VinhHoang on 16/03/2023.
//

import UIKit

class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "id"
    private let headerId = "headerId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(AppGroupCell.self, forCellWithReuseIdentifier: cellId)
        
        // 1
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = self.socialApps
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    // 3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppGroupCell
        let appGroup = groups[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - API CALLS
    // states
    var groups: [AppGroup] = []
    var socialApps: [SocialApp] = []
    
    fileprivate func fetchData() {

        let dispatchGroup = DispatchGroup()
        var topPaids: AppGroup?
        var musics: AppGroup?
        var audiobooks: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let objects):
                self.socialApps = objects ?? []
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.enter()
        Service.shared.fetchTopPaid { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let appGroup):
                if let group = appGroup {
                    topPaids = group
                }
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.enter()
        Service.shared.fetchTopMostPlayedMusic { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let appGroup):
                if let group = appGroup {
                    musics = group
                }
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.enter()
        Service.shared.fetchTopAudioBooks { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let appGroup):
                if let group = appGroup {
                    audiobooks = group
                }
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.activityIndicatorView.stopAnimating()
            if let topPaids = topPaids {
                self.groups.append(topPaids)
            }
            if let musics = musics {
                self.groups.append(musics)
            }
            if let audiobooks = audiobooks {
                self.groups.append(audiobooks)
            }
            self.collectionView.reloadData()
        }
    }
}
