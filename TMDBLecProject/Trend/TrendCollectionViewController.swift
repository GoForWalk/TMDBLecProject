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
    
}

class TrendCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var trendCollectionView: UICollectionView!
    
    let genreDB = GenreDB.shared
    
    var dataArray: [TrendData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trendCollectionView.delegate = self
        trendCollectionView.dataSource = self
        trendCollectionView.collectionViewLayout = setCellSize()
        
        setUI()
        fetchData()
    }
    
    func setUI() {
        
        trendCollectionView.backgroundColor = .yellow.withAlphaComponent(0)
    }
    
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
        let numOfCell: CGFloat = 1
        let numOfSpace: CGFloat = numOfCell + 1
        
//        let width = (UIScreen.main.bounds.width - (spacing * numOfSpace)) / numOfCell
        let width = UIScreen.main.bounds.width
        
        layout.minimumLineSpacing = 100
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: width * 1.15)
        layout.sectionInset = UIEdgeInsets(top: 50, left: 0, bottom: spacing, right: 0)
        
        // viewDidLoad 에 추가 코드
        // collectionView.collectionViewLayout = layout
        return layout
    }

    
    func fetchData() {
        
        let urlString = "\(EndPoint.trendURL)?api_key=\(APIKey.TMDB_KEY)"
        
        let formatter = DateFormatter()
        
        
        
        AF.request(urlString).validate().responseJSON { response in
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print(json)
                
                let trends = json["results"]
                
                print(trends.count)
                
                trends.forEach { (_ ,json) in
                    let name = json["name"].stringValue
        
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    let date = formatter.date(from: json["first_air_date"].stringValue)
                    let rate = json["vote_average"].doubleValue
                    let imageURL = json["poster_path"].stringValue
                    let description = json["overview"].stringValue
                    let genres = json["genre_ids"].arrayObject as! [Int]
                    
                    formatter.dateFormat = "dd/MM/yyyy"
                    
                    self.dataArray.append(TrendData(date: formatter.string(from: date!), genres: genres, title: name, imageURLString: imageURL, rate: "\(round(rate * 100) / 100.0)", description: description))
                }
                
                self.trendCollectionView.reloadData()
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
}
