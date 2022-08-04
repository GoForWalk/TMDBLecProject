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
    
}

class TrendCollectionViewController: UIViewController {
    
    @IBOutlet weak var trendCollectionView: UICollectionView!
    
    let genreDB = GenreDB.shared
    
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
    }
    
    func fetchData(startPage: Int) {
        
        let urlString = "\(EndPoint.trendURL)?api_key=\(APIKey.TMDB_KEY)"
        
        let params: Parameters = ["api_key":"\(APIKey.TMDB_KEY)", "page": startPage]
        
        let formatter = DateFormatter()
        
        AF.request(urlString, method: .get, parameters: params ).validate().responseJSON { response in
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print(json)
                
                let trends = json["results"]
                self.totalCell = json["total_results"].intValue
                print(trends.count)
                
                trends.forEach { (_ ,json) in
                    let name = json["name"].stringValue
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    let date = formatter.date(from: json["first_air_date"].stringValue)
                    let rate = json["vote_average"].doubleValue
                    let imageURL = json["poster_path"].stringValue
                    let description = json["overview"].stringValue
                    let genres = json["genre_ids"].arrayObject as! [Int]
                    let tvid = json["id"].intValue
                    let wildImageURL = json["backdrop_path"].stringValue
                    
                    formatter.dateFormat = "dd/MM/yyyy"
                    
                    self.dataArray.append(TrendData(date: formatter.string(from: date!), genres: genres, title: name, imageURLString: imageURL, rate: "\(round(rate * 100) / 100.0)", description: description, tvID: tvid, wildImageURLString: wildImageURL))
                }
                
                self.trendCollectionView.reloadData()
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
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
