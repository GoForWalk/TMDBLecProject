//
//  TrendDB.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/03.
//

import Foundation

class GenreDB {
    
    static let shared = GenreDB()
    
    private init () {}
    
    private var tvGenre: [String:String] = [:]
    
    func appendGenre(key: Int, value: String) {
        tvGenre["\(key)"] = value
    }
        
    func searchGenreFromData(key: Int) -> String? {
        let userdic = getGenreFromUserDefaults()
        return userdic["\(key)"]
    }
    
    func setGenreToUserDefaults() {
        UserDefaults.standard.set(tvGenre, forKey: UserDefaultsKeys.tvGenre)
    }
    
    func getGenreFromUserDefaults() -> [String : String]{
        UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.tvGenre) as! [String: String]
    }
    
}
