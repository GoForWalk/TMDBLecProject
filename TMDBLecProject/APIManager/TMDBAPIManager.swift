//
//  TrendAPIManager.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager: APIProtocol {
    
    static let shared = TMDBAPIManager()
    
    private init () { }

    func fetchTrendAPI(startPage: Int, completionHandler: @escaping (Int, [TrendData]) -> Void) {
        
        let urlString = "\(EndPoint.trendURL)?api_key=\(APIKey.TMDB_KEY)"
        
        let params: Parameters = ["api_key":"\(APIKey.TMDB_KEY)", "page": startPage]
        
        let formatter = DateFormatter()
        
        AF.request(urlString, method: .get, parameters: params ).validate().responseData(queue: .global(qos: .default)) { response in
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print(json)
                
                let totalCell = json["total_results"].intValue // Int
                
                let trends = json["results"].arrayValue
                let resultArray: [TrendData] = trends.map { json -> TrendData in
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
                    
                    return TrendData(date: formatter.string(from: date!), genres: genres, title: name, imageURLString: imageURL, rate: "\(round(rate * 100) / 100.0)", description: description, tvID: tvid, wildImageURLString: wildImageURL)
                }
                
                completionHandler(totalCell, resultArray)
            case .failure(let error):
                print("error: \(error)")
            }
        }
        
    }//: fetchTrendAPI
    
    func fetchCastAPI(trendData: TrendData?, completionHandler: @escaping ([ActorInfo]) -> Void) {
        
        let url = EndPoint.creditURL(tvID: trendData!.tvID)
        
        let quaryString: Parameters = ["api_key": APIKey.TMDB_KEY]
        
        AF.request(url, method: .get, parameters: quaryString).validate().responseData(queue: .global(qos: .default)) { response in
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                
                let tempData = json["cast"].arrayValue
                
                let resultArray: [ActorInfo] = tempData.map { json -> ActorInfo in
                    let actorName = json["original_name"].stringValue
                    let characterName = json["character"].stringValue
                    let actorImageURLString = json["profile_path"].string

                    return ActorInfo(actorName: actorName, actorImageURLString: actorImageURLString, characterName: characterName)
                }
                
                completionHandler(resultArray)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }//: fetchCastAPI
    
    // TODO: GenreData
    
    
}//: TMDBAPIManager
