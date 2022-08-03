//
//  AppDelegate.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let genreDB = GenreDB.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        fetchGenre()
        return true
    }
    
    func fetchGenre() {
        
        let urlString = "\(EndPoint.gerneURL)?api_key=\(APIKey.TMDB_KEY)"
        
        AF.request(urlString).validate().responseJSON { response in
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                
                let genres = json["genres"]
                
                genres.forEach { (_ , json) in
                    let key = json["id"].intValue
                    let value = json["name"].stringValue
                    
                    self.genreDB.appendGenre(key: key, value: value)
                }
                
                print("fetch Done: genreData")
                
            case .failure(let error):
                print(error)
            }
            
            
        }
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

