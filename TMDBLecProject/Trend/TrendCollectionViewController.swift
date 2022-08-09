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
import JGProgressHUD


struct TrendData {
    
    var date: String?
    var genres: [Int]
    var title: String
    var imageURLString: String
    var rate: String
    var description: String
    var tvID: Int
    var wildImageURLString: String
    var isCliped: Bool = false
    
}

final class TrendCollectionViewController: OrientationPortraitLockedViewController {
    
    @IBOutlet weak var trendCollectionView: UICollectionView!
    
    let genreDB = GenreDB.shared
    let trendAPIManager = TMDBAPIManager.shared
    let searchController = UISearchController(searchResultsController: nil)
    let hud = JGProgressHUD()
    
    var startPage = 1
    var totalCell = 0
    
    var dataArray: [TrendData] = []
    var searchDataArray: [TrendData] = []
    var isSearching = false
    var searchingWord = ""
    var textNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trendCollectionView.delegate = self
        trendCollectionView.dataSource = self
        trendCollectionView.collectionViewLayout = setCellSize()
        trendCollectionView.prefetchDataSource = self
        
        setUI()
        fetchData(startPage: startPage, isSearching: isSearching)
    }
            
    func setUI() {
        trendCollectionView.backgroundColor = .yellow.withAlphaComponent(0)
        setNav()
        hud.textLabel.text = "Loading"
    }
    
}

// MARK: Navigation Set
extension TrendCollectionViewController {
    
    func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navRightButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: #selector(navLeftButtonTapped))
        
        //MARK: UISearchContoller 적용 코드
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    @objc
    func navRightButtonTapped() {
        
        guard let vc = UIStoryboard(name: StoryBoradIDs.tvProgramsViewController, bundle: nil).instantiateViewController(withIdentifier: TVProgramsViewController.identifier) as? TVProgramsViewController else { return }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true)
    }
    
    @objc
    func navLeftButtonTapped() {
        
    }
    
}

// MARK: FetchingAPI
extension TrendCollectionViewController {
    
    func fetchData(startPage: Int, isSearching: Bool) {
        trendAPIManager.fetchTrendAPI(startPage: startPage) { [weak self] totalCell, newDataArray in
            
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.hud.show(in: self.view, animated: true)
            }
            
            self.totalCell = totalCell
            self.dataArray.append(contentsOf: newDataArray)
            
            if isSearching {
                self.searchDataArray.append(contentsOf: newDataArray.filter{
                    $0.title.trimmingCharacters(in: .whitespaces).contains(self.searchingWord)
                })
            }
            
            DispatchQueue.main.async {
                self.trendCollectionView.reloadData()
                self.hud.dismiss(afterDelay: 0.5 ,animated: true)
            }
        }
    }

}

// MARK: UISearchBarDelegate: 검색기능
extension TrendCollectionViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
        isSearching = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function, searchText)
        isSearching = true

        if textNum == 0 { textNum = 1}
        self.searchingWord = searchText
                
        if searchDataArray.isEmpty || textNum > searchText.count {
            textNum = searchText.count
            searchDataArray = dataArray.filter {
                return $0.title.trimmingCharacters(in: .whitespaces).lowercased().contains(searchText.lowercased())
            }
    
        } else {
            textNum += 1
            searchDataArray = searchDataArray.filter {
                return $0.title.trimmingCharacters(in: .whitespaces).lowercased().contains(searchText.lowercased())
            }
        }
        
        
        if searchDataArray.count < 5, dataArray.count <= 200 {
            
            startPage += 1
            fetchData(startPage: startPage, isSearching: isSearching)
            self.trendCollectionView.reloadData()
            print("searchwork: ", searchingWord, " textNum: ", textNum, " arrayCount: ", dataArray.count)
            return
        }
        
        self.trendCollectionView.reloadData()
        print("searchwork: ", searchingWord, " textNum: ", textNum, " arrayCount: ", dataArray.count)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        textNum = 0
        isSearching = false
        self.trendCollectionView.reloadData()
        self.trendCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension TrendCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        switch isSearching {
        case false: return dataArray.count
        case true: return searchDataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as? TrendCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell()
        
        switch isSearching {
        case false:
            cell.setData(trendData: dataArray[indexPath.row])

        case true:
            print("searchDataArray.count: ", searchDataArray.count, " dataArray: ", dataArray.count)

            cell.setData(trendData: searchDataArray[indexPath.row])
        }
        
        return cell
    }

    func setCellSize() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        let width = UIScreen.main.bounds.width
        
        layout.minimumLineSpacing = 60
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: width * 1.15)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: spacing, right: 0)
        
        return layout
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: TVDetailViewController.identifier) as? TVDetailViewController else { return }
        
        switch isSearching {
        case false: vc.trendData = dataArray[indexPath.item]
        case true: vc.trendData = searchDataArray[indexPath.item]
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: UICollectionViewDataSourcePrefetching / Pagenation
extension TrendCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function)
        
        for indexPath in indexPaths {
            if dataArray.count - 1 == indexPath.item, dataArray.count < totalCell, !isSearching {
                print(#function, " isSearching ", indexPath)
                startPage += 1
                fetchData(startPage: startPage, isSearching: isSearching)
            }
            
            if searchDataArray.count - 1 == indexPath.item, dataArray.count < totalCell, isSearching {
                print(#function, " isSearching ", indexPath)
                startPage += 1
                fetchData(startPage: startPage, isSearching: isSearching)
            }
        }
    }
}
