//
//  TrendAPIManager.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init () {}
    
    let genreDB = GenreDB.shared
    let formatter = DateFormatter()
    
    func fetchTrendAPI(startPage: Int, completionHandler: @escaping (Int, [TrendData]) -> Void) {
        print(#function, "start")
        
        let urlString = EndPoint.trendURL
        let params: Parameters = [APIKey.TMDB_KEY_PARAM: APIKey.TMDB_KEY, APIKey.TMDB_PAGE_PARAM: startPage]
        
        
        AF.request(urlString, method: .get, parameters: params ).validate().responseData(queue: .global(qos: .default)) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
//                print(json)
                
                let totalCell = json["total_results"].intValue // Int
                
                let trends = json["results"].arrayValue
                let resultArray: [TrendData] = trends.map { json -> TrendData in
                    let name = json["name"].stringValue
                    
                    self.formatter.dateFormat = "yyyy-MM-dd"
                    
                    let date = self.formatter.date(from: json["first_air_date"].string ?? "1900-01-01")
                    let rate = json["vote_average"].doubleValue
                    let imageURL = json["poster_path"].stringValue
                    let description = json["overview"].stringValue
                    let genres = json["genre_ids"].arrayObject as! [Int]
                    let tvid = json["id"].intValue
                    let wildImageURL = json["backdrop_path"].stringValue
                    
                    self.formatter.dateFormat = "dd/MM/yyyy"
                    
                    let dateString = date != nil ? self.formatter.string(from: date!) : "날짜 없음"
                    
                    return TrendData(date: dateString, genres: genres, title: name, imageURLString: imageURL, rate: "\(round(rate * 100) / 100.0)", description: description, tvID: tvid, wildImageURLString: wildImageURL)
                }
                print(#function, "done")
                completionHandler(totalCell, resultArray)
            case .failure(let error):
                print("error: \(error)")
            }
        }
        
    }//: fetchTrendAPI
    
    func fetchCastAPI(trendData: TrendData?, completionHandler: @escaping ([ActorInfo]) -> Void) {
        print(#function, "start")
        
        let url = EndPoint.creditURL(tvID: trendData!.tvID)
        let quaryString: Parameters = [APIKey.TMDB_KEY_PARAM: APIKey.TMDB_KEY]
        
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
                print(#function, "done")
                completionHandler(resultArray)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }//: fetchCastAPI
    
    func fetchGenreAPI() {
        print(#function, "start")
        
        let urlString = EndPoint.gerneURL
        let params: Parameters = [APIKey.TMDB_KEY_PARAM: APIKey.TMDB_KEY]
        
        AF.request(urlString, method: .get, parameters: params).validate().responseData(queue: .global(qos: .background)) { [weak self] response in

            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                
//                print(json)
                let genres = json["genres"]
                
                genres.forEach { (_ , json) in
                    let key = json["id"].intValue
                    let value = json["name"].stringValue

                    self.genreDB.appendGenre(key: key, value: value)
                }
                                
                self.genreDB.setGenreToUserDefaults()
                print(#function, "done")
                
            case .failure(let error):
                print(error)
            }
        }

    }//: fetchGenreAPI
    
    func fetchTVIntoAPI(tvID: Int, completionHandler: @escaping (String, String) -> Void) {
        print(#function, "start")

        let urlString = EndPoint.videoURL(tvID: tvID)
        let params: Parameters = [APIKey.TMDB_KEY_PARAM: APIKey.TMDB_KEY]
        
        AF.request(urlString, method: .get, parameters: params).validate().responseData(queue: .global(qos: .userInteractive)) { response in
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
//                print(json)
                
                let into = json["results"].array
                
                guard let into = into else {
                    print(#function, "Error: none TVIntoURL")
                    return }
                
                let firstInto = into[0]
                
                let introSite = firstInto["site"].stringValue
                let introKey = firstInto["key"].stringValue
                
                completionHandler(introSite, introKey)
                
                print(#function, "done")
            case .failure(let error):
                print(#function, "error:", error)
            }
        }
        
    }//: fetchTVIntoAPI
    
}//: TMDBAPIManager
