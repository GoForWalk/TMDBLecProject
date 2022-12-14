//
//  TVProgramsViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

class TVProgramsViewController: OrientationPortraitLockedViewController {

    let tmdbAPIManager = TMDBAPIManager.shared
    var trendDataArray: [TrendData] = []
    
    let colors: [UIColor] = [.red, .lightGray, .cyan, .orange, .yellow, .green, .magenta]
    
    var recommendArray: [[String]] = []
    
    @IBOutlet weak var tvBannerCollectionView: UICollectionView!
    @IBOutlet weak var tvProgramsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBannerColletionView()
        setTVProgramsTableView()
        fetchRecommendData(data: trendDataArray)
    }
    
    func setUI() {
        self.view.backgroundColor = .lightGray
    }

}

// MARK: BannerCollectionView Set
extension TVProgramsViewController {

    private func setBannerColletionView() {
        
        tvBannerCollectionView.delegate = self
        tvBannerCollectionView.dataSource = self
        
        tvBannerCollectionView.register(UINib(nibName: TVBannerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TVBannerCollectionViewCell.identifier)
        
        tvBannerCollectionView.isPagingEnabled = true
        tvBannerCollectionView.collectionViewLayout = setBannerCollectionViewLayout()
        
    }

    private func setBannerCollectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: tvBannerCollectionView.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}

// MARK: tvProgramsTableView Set
extension TVProgramsViewController {
    
    private func setTVProgramsTableView() {
        tvProgramsTableView.delegate = self
        tvProgramsTableView.dataSource = self
        
        tvProgramsTableView.register(UINib(nibName: TVProgramsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TVProgramsTableViewCell.identifier)
        
        tvProgramsTableView.backgroundColor = .lightGray
    }
    
}

// MARK: Fetching Data
extension TVProgramsViewController {

    func fetchRecommendData(data: [TrendData]) {
        
        tmdbAPIManager.getRecommendData(data: data) { result in
            self.recommendArray = result
            print(result)
            
            DispatchQueue.main.async {
                self.tvProgramsTableView.reloadData()
            }
        }
        
    }
}

// MARK: UICollection Protocols
extension TVProgramsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == tvBannerCollectionView ? colors.count : recommendArray[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tvBannerCollectionView {
            guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TVBannerCollectionViewCell.identifier, for: indexPath) as? TVBannerCollectionViewCell else { return UICollectionViewCell()}
            
            var tempItem = indexPath.item
            
            if indexPath.item == colors.count {
                tempItem = 0
            }
            
            bannerCell.tvBannerView.opacityView.backgroundColor = colors[tempItem].withAlphaComponent(0.3)
            return bannerCell
        } else {
            
            guard let tvCell = collectionView.dequeueReusableCell(withReuseIdentifier: TVProgramsCollectionViewCell.identifier, for: indexPath) as? TVProgramsCollectionViewCell else { return UICollectionViewCell()}
            
            let url = URL(string: "\(EndPoint.imageURL)\(recommendArray[collectionView.tag][indexPath.item])")
            
//            tvCell.tvProgramsThumbnailView.thumbnailTitleLabel.text = "\(recommendArray[collectionView.tag][indexPath.item])"
            tvCell.tvProgramsThumbnailView.thumbnailImageView.kf.setImage(with: url)
            return tvCell
        }
    }
    
}

// MARK: UITableView Protocols
extension TVProgramsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recommendArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TVProgramsTableViewCell.identifier, for: indexPath) as? TVProgramsTableViewCell else { return UITableViewCell() }
        
        cell.tvProgramsCollectionView.tag = indexPath.section
        cell.genreLabel.text = trendDataArray[indexPath.section].title
        cell.tvProgramsCollectionView.delegate = self
        cell.tvProgramsCollectionView.dataSource = self
        cell.tvProgramsCollectionView.register(UINib(nibName: TVProgramsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TVProgramsCollectionViewCell.identifier)
//        print(cell.tvProgramsCollectionView.tag, "====",  cell.tvProgramsCollectionView.description)
        cell.tvProgramsCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 8 + 8 + 130 + 28 + 8
    }
    
}
