//
//  TrendCollectionViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/03.
//

import UIKit

import Kingfisher
import Alamofire
import SwiftyJSON

struct TrendData {
    
    var date: String
    var genres: [Int]
    var title: String
    var imageURLString: String
    var rate: String
    var description: String
    var tvID: Int
    var wildImageURLString: String
    var isCliped: Bool = false
    
}

class TrendCollectionViewController: UIViewController {
    
    @IBOutlet weak var trendCollectionView: UICollectionView!
    
    let genreDB = GenreDB.shared
    let trendAPIManager = TMDBAPIManager.shared
    
    var startPage = 1
    var totalCell = 0
    
    var dataArray: [TrendData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trendCollectionView.delegate = self
        trendCollectionView.dataSource = self
        trendCollectionView.collectionViewLayout = setCellSize()
        trendCollectionView.prefetchDataSource = self
        
        setUI()
        fetchData(startPage: startPage)
    }
    
    func setUI() {
        trendCollectionView.backgroundColor = .yellow.withAlphaComponent(0)
        setNav()
    }
    
    func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navRightButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: #selector(navLeftButtonTapped))
        
        //MARK: UISearchContoller 적용 코드
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        
    }
    
    @objc
    func navRightButtonTapped() {
        
    }
    
    @objc
    func navLeftButtonTapped() {
        
    }
    
    func fetchData(startPage: Int) {
        trendAPIManager.fetchTrendAPI(startPage: startPage) { totalCell, newDataArray in
            self.totalCell = totalCell
            self.dataArray.append(contentsOf: newDataArray)
            
            DispatchQueue.main.async {
                self.trendCollectionView.reloadData()
            }
        }
    }
    
}

// MARK: UISearchBarDelegate
extension TrendCollectionViewController: UISearchBarDelegate {
    
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension TrendCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as? TrendCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell()
        cell.setData(trendData: dataArray[indexPath.row])
        
        return cell
    }

    func setCellSize() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        let width = UIScreen.main.bounds.width
        
        layout.minimumLineSpacing = 100
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: width * 1.15)
        layout.sectionInset = UIEdgeInsets(top: 50, left: 0, bottom: spacing, right: 0)
        
        return layout
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: TVDetailViewController.identifier) as? TVDetailViewController else { return }
        vc.trendData = dataArray[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: UICollectionViewDataSourcePrefetching / Pagenation
extension TrendCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if dataArray.count - 1 == indexPath.item, dataArray.count < totalCell  {
                
                startPage += 1
                fetchData(startPage: startPage)
                
            }
        }
    }
}
